//
//  Ad4MaxBannerView.m
//  Ad4Max SDK 1.0
//
//  Copyright 2011 Publigroupe
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

// ============================================================================


#import "Ad4MaxBannerViewDelegate.h"
#import "Ad4MaxParamsService.h"

#import "Ad4MaxBannerView.h"

#import "Ad4MaxInternals.h"

#import <CoreLocation/CoreLocation.h>


static const int DEFAULT_REFRESH_RATE = 45;
static const int MIN_REFRESH_RATE = 30;

@interface Ad4MaxBannerView ()

// Private properties and methods
@property (nonatomic, retain) UIWebView*            activeWebView;
@property (nonatomic, retain) UIWebView*            inactiveWebView; // used for animation
@property (nonatomic, retain) Ad4MaxParamsService*  paramsService;
@property (nonatomic, retain) NSTimer*              refreshTimer;

- (void)baseInit;
- (void)initActiveWebView;

- (void)didBecomeActive:(NSNotification *)notification;
- (void)willResignActive:(NSNotification *)notification;
- (void)orientationDidChange:(NSNotification *)notification;

- (NSString*)getWebViewContent;
- (NSString*)getLocationString:(CLLocation*)location;

- (void)loadBannerInView;
- (void)scheduleAdRefresh;
- (void)changeAd;

- (void)reportBannerSizeErrorWithHeight:(int)height andWidth:(int)width;
- (void)reportError:(NSString*)errorMsg withCode:(NSInteger)code;


@end


@implementation Ad4MaxBannerView

@synthesize ad4MaxDelegate, bannerLoaded;
@synthesize activeWebView, inactiveWebView, paramsService, refreshTimer;

#pragma mark -
#pragma mark - Memory Management

- (void)dealloc
{
    // Unregister from notifications
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    initialized = NO;
    
    self.ad4MaxDelegate = nil;
    
    self.activeWebView = nil;
    self.inactiveWebView = nil;
    self.paramsService = nil;
    self.refreshTimer = nil;
    
    [super dealloc];
}

- (void)baseInit {
 
    self.paramsService = [[[Ad4MaxParamsService alloc] init] autorelease];
    
#ifdef AD4MAXTEST    
    // Do not do UIKit related things in unit tests, it crashes
    return;
#endif

    self.inactiveWebView = nil;
    [self initActiveWebView];

    // add webView to View
    [self addSubview:activeWebView];        
    
    // make sure the layout stays correct if the outer superview is resized
    self.autoresizesSubviews = YES;
    
    [self setOpaque:NO]; 
    self.backgroundColor = [UIColor clearColor];

    bannerLoaded = NO;

    // Register for orientation change event
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:@"UIApplicationDidChangeStatusBarOrientationNotification" object:nil];

    // Register for application lifecycle events
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    
    initialized = YES;
    
    if( ad4MaxDelegate ) {
        [self loadBannerInView];        
    }
}

- (void)initActiveWebView {
 
    self.activeWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)] autorelease];

    activeWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    [activeWebView setOpaque:NO]; 
    activeWebView.backgroundColor = [UIColor clearColor];
    [activeWebView setDelegate:self];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self baseInit];
}

#pragma mark -
#pragma mark - Application Lifecycle management

- (void)didBecomeActive:(NSNotification *)notification {

    // Schedule next ad refresh
    [self scheduleAdRefresh];    
}

- (void)willResignActive:(NSNotification *)notification {
    
    // Cancel ad refresh as long as ads are not visible
    AD4MAXDLOG(@"Cancelling ad refresh timer...");
    [refreshTimer invalidate];
}

- (void)orientationDidChange:(NSNotification *)notification {

    // Reload the ad to give the developer the opportunity to change
    // its ad format
    AD4MAXDLOG(@"Reloading ad as the orientation has changed...");

    [[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[[self subviews] objectAtIndex:idx] setCenter:self.center];
    }];
    
    [refreshTimer invalidate];
    [self performSelector:@selector(changeAd) withObject:nil afterDelay:1.0];

}

#pragma mark -
#pragma mark - Public methods

- (void)setAd4MaxDelegate:(id<Ad4MaxBannerViewDelegate>)_delegate {
    
    ad4MaxDelegate = _delegate;

    // The load sequence is different if the delegate is set via IB or
    // programmatically
    // In case of IB, delegate is set before the call to awakeFromNib
    // If done programmatically in controller viewDidLoad, delegate is set after
    // the call to awakeFromNib
    if( initialized ) {
        [self loadBannerInView];    
    }
}


#pragma mark -
#pragma mark - Private methods

- (NSString*)getWebViewContent {
        
    // set web view content
    NSString *htmlStringFormat = @""
    "<html>"
    "<head>"
    "<title></title>"
    "<style type='text/css'>html, body { margin: 0; padding: 0; } div#container { text-align: center; }</style>"
    "</head>"
    "<body>"
    "<div id='container'>"
    "<script type='text/javascript'>"
    "ad4max_guid = '%@';"
    "ad4max_app_name = '%@';"
    "ad4max_app_version = '%@';"
    "ad4max_uid = '%@';"
    "ad4max_lang = '%@';"
    "ad4max_connection_type = '%@';"
    "ad4max_width = '%@';"
    "ad4max_height = '%@';"
    "%@"
    "</script>"
    "<script type='text/javascript' src='http://%@/ad4max.js'></script>"
    "<div>"
    "</body>"
    "</html>";
    
    NSString *guidString = [ad4MaxDelegate getAdBoxId];
    // TODO validate URL
    NSString *serverURLString = [ad4MaxDelegate getAdServerURL];
    NSString *widthString = [NSString stringWithFormat: @"%.0f", super.frame.size.width];
    NSString *heightString = [NSString stringWithFormat: @"%.0f", super.frame.size.height];
    
    NSString *uidString = [paramsService getUID];
    NSString *appNameString = [paramsService getAppName];
    NSString *appVersionString = [paramsService getAppVersion];
    NSString *langString = [paramsService getLang];
    NSString *connectionTypeString = [paramsService getConnectionType];
    
    // Handle optional parameters
    NSMutableString *optionalParamsString = [[[NSMutableString alloc] init] autorelease];
    NSString *carrierNameString = [paramsService getCarrierName];
    if(carrierNameString) {
        [optionalParamsString appendFormat:@"ad4max_carrier = '%@';", carrierNameString];
    }
    if([paramsService isFirstLaunch]) {
        [optionalParamsString appendFormat:@"ad4max_first_launch = '1';"];
    }
    
    // Handle optional delegate methods
    if ([ad4MaxDelegate respondsToSelector:@selector(getUserGeoLocation)] ) {

        CLLocation* location = [ad4MaxDelegate getUserGeoLocation];
        
        if (location) {
            [optionalParamsString appendFormat:@"ad4max_geo = '%@';", [self getLocationString:location]];
        }
    }
    if ([ad4MaxDelegate respondsToSelector:@selector(doForceLanguage)] ) {
        if ([ad4MaxDelegate doForceLanguage]) {
            [optionalParamsString appendFormat:@"ad4max_lang_filter = 'on';"];
        } 
        else {
            [optionalParamsString appendFormat:@"ad4max_lang_filter = 'off';"];
        }
    }
    if ([ad4MaxDelegate respondsToSelector:@selector(getTargetedPublisherCategories)] ) {
        // TODO check format cat1;cat2;cat3 (max 3)
        if ([ad4MaxDelegate getTargetedPublisherCategories]) {
            [optionalParamsString appendFormat:@"ad4max_publisher_categories = '%@';", [ad4MaxDelegate getTargetedPublisherCategories]];
        }
    }
        
        
    NSString *generatedHTMLString = [[[NSString alloc] initWithFormat:htmlStringFormat, 
                                     guidString, 
                                     appNameString,
                                     appVersionString,
                                     uidString,
                                     langString,
                                     connectionTypeString,
                                     widthString, 
                                     heightString, 
                                     optionalParamsString,
                                     serverURLString ] autorelease];
    
    AD4MAXDLOG(@"%@", generatedHTMLString);
    
    return generatedHTMLString;
}

- (NSString*)getLocationString:(CLLocation*)location {

    CLLocationAccuracy locationInKM = location.horizontalAccuracy / 1000;
    
    return [NSString stringWithFormat: @"%f;%f;%f", location.coordinate.latitude, location.coordinate.longitude, locationInKM];
}

- (void)loadBannerInView {
    
    if( !ad4MaxDelegate ) {
        [self reportError:@"ERROR: you did not set any delegate for your ad4Max banner" withCode:Ad4MaxConfigurationError];
        return;
    }
    
    if( ![ad4MaxDelegate respondsToSelector:@selector(getAdBoxId)] ) {
        [self reportError:@"ERROR: your delegate for ad4Max banner does not implement mandatory method getAdBoxId" withCode:Ad4MaxConfigurationError];
        return;
    }
    
    if( ![ad4MaxDelegate respondsToSelector:@selector(getAdServerURL)] ) {
        [self reportError:@"ERROR: your delegate for ad4Max banner does not implement mandatory method getAdServerURL" withCode:Ad4MaxConfigurationError];
        return;
    }

    cntWebViewLoads = 0;
    bannerLoaded = NO;
    
    [activeWebView loadHTMLString:[self getWebViewContent] baseURL:nil];    

    // Report event to delegate
    if ([ad4MaxDelegate respondsToSelector:@selector(bannerViewWillLoadAd:)] ) {
        [self.ad4MaxDelegate bannerViewWillLoadAd:self];
    }
    
    // Schedule next ad refresh
    [self scheduleAdRefresh];
        
}

- (void)scheduleAdRefresh {
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        AD4MAXDLOG(@"Not scheduling ad refresh because application is inactive...");        
        return;
    }

    NSUInteger refreshRate = DEFAULT_REFRESH_RATE;
    if ([ad4MaxDelegate respondsToSelector:@selector(getAdRefreshRate)] ) {
        refreshRate = [ad4MaxDelegate getAdRefreshRate];
        if( refreshRate != 0 && refreshRate < MIN_REFRESH_RATE ) {
            refreshRate = MIN_REFRESH_RATE;
        }
    }
    if( refreshRate != 0 ) {
        AD4MAXDLOG(@"Scheduling ad refresh in %d sec", refreshRate);
        [refreshTimer invalidate];
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshRate target:self selector:@selector(changeAd) userInfo:nil repeats:NO];
    }

}

- (void)changeAd {

    [activeWebView stopLoading];

    self.inactiveWebView = activeWebView;
    [self initActiveWebView];

    [self loadBannerInView];
}

#pragma mark -
#pragma mark - UIWebViewDelegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {

        // Ask to app whether it is ok to leave app
        if(   ![ad4MaxDelegate respondsToSelector:@selector(bannerViewActionShouldBegin:willLeaveApplication:)] 
           || [self.ad4MaxDelegate bannerViewActionShouldBegin:self willLeaveApplication:YES] ) {
            
            [[UIApplication sharedApplication] openURL:[inRequest URL]];        
        }
        return NO;
    }

    // Track number of page loaded
    cntWebViewLoads++;

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
            
    // Report event to delegate
    if( --cntWebViewLoads == 0  ) {
    
        // Check size of the view is correct
        int height = [[activeWebView stringByEvaluatingJavaScriptFromString:@"document.body.getElementsByTagName('iframe').item(0).contentWindow.document.body.offsetHeight;"] intValue];
        int width = [[activeWebView stringByEvaluatingJavaScriptFromString:@"document.body.getElementsByTagName('iframe').item(0).contentWindow.document.body.offsetWidth;"] intValue];
        
        
        if( height == 0 && width == 0 ) {
            // Problem loading iframe content
            [self reportError:@"ERROR: failed to load ad4Max banner, server is not responding correctly (server failure)" withCode:Ad4MaxServerFailureError]; 
            return;
        }
        else if( height == 0 && width == (int)self.frame.size.width ) {            
            // No Ad available
            // Today we are not able to make the difference between an error 
            // on the AD BOX id and the fact that no ad is available            
            [self reportError:@"ERROR: either you AD BOX id is not valid or no ad banner is currently available for your application. You can hide this banner until a new ad becomes available" withCode:Ad4MaxNoAdsAvailableError]; 
            return;            
        }
        
        // This is reported as an error but we though report that the Ad has loaded
        if( height != (int)self.frame.size.height || width != (int)self.frame.size.width ) {
            [self reportBannerSizeErrorWithHeight:height andWidth:width];
        }

        bannerLoaded = YES;

        [UIView transitionFromView:inactiveWebView toView:activeWebView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];

        if( [ad4MaxDelegate respondsToSelector:@selector(bannerViewDidLoadAd:)] )
            [self.ad4MaxDelegate bannerViewDidLoadAd:self];
    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)_error {

    // Do not decrement cntWebViewLoads to avoid having webViewDidFinishLoad
    // called    

    // Handle errors
    if ([_error code] == NSURLErrorCancelled) {
        // Ignore this error, it means we aborted an unfinished request
        return;
    }
    else if ([_error code] == -1009) {
        [self reportError:@"ERROR: unable to load a ad4Max banner, your Internet collection appears to be offline" withCode:Ad4MaxNetworkNotReachableError];    
    }
    else {
        [self reportError:[_error description] withCode:Ad4MaxUnknownError];
    }
}

#pragma mark -
#pragma mark - Error management

- (void)reportBannerSizeErrorWithHeight:(int)height andWidth:(int)width {
    
    NSString *errorMsg = [[[NSString alloc] initWithFormat:@"ERROR: your ad4Max banner is not of the size configured in your AD BOX. Your ad4MaxBanner is %d x %d and your configured AD BOX size is %d x %d", (int)self.frame.size.height, (int)self.frame.size.width, height, width] autorelease];
    
    [self reportError:errorMsg withCode:Ad4MaxBannerSizeError];
}

- (void)reportError:(NSString*)errorMsg withCode:(NSInteger)code {

    if (![ad4MaxDelegate respondsToSelector:@selector(bannerView:didFailToReceiveAdWithError:)] ) {
        
        NSLog(@"ERROR: your delegate for ad4Max banner %@ does not implement mandatory method bannerView:didFailToReceiveAdWithError:", self);  
        // Log the inital message anyway
        NSLog(@"%@", errorMsg);        
        return;
    }
    
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:errorMsg forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"ad4Max" code:code userInfo:errorDetail];
    
    [ad4MaxDelegate bannerView:self didFailToReceiveAdWithError:error];
}


@end
    
