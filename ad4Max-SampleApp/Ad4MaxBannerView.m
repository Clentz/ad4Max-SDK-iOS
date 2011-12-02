//
//
//  Ad4MaxBannerView.m
//  ad4Max-SampleApp
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


@interface Ad4MaxBannerView ()

// Private properties and methods
@property (nonatomic, retain) UIWebView*            activeWebView;
@property (nonatomic, retain) UIWebView*            inactiveWebView; // used for animation
@property (nonatomic, retain) Ad4MaxParamsService*  paramsService;
@property (nonatomic, retain) NSTimer*              refreshTimer;

- (void)baseInit;
- (void)initActiveWebView;
- (void)loadBannerInView;

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
    self.ad4MaxDelegate = nil;
    self.activeWebView = nil;
    self.inactiveWebView = nil;
    self.paramsService = nil;
    
    initialized = NO;
    
    [super dealloc];
}

- (void)baseInit {
 
    self.paramsService = [[[Ad4MaxParamsService alloc] init] autorelease];
    
    self.inactiveWebView = nil;
    [self initActiveWebView];
    
    // add webView to View
    [self addSubview:activeWebView];        
    
    // make sure the layout stays correct if the outer superview is resized
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self setOpaque:NO]; 
    self.backgroundColor = [UIColor clearColor];

    initialized = YES;
    bannerLoaded = NO;
    
    [self loadBannerInView];        
}

- (void)initActiveWebView {
 
    self.activeWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)] autorelease];
    
    for (id subview in activeWebView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;

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
#pragma mark - Public methods

- (void)setAd4MaxDelegate:(id<Ad4MaxBannerViewDelegate>)_delegate {
    
    ad4MaxDelegate = _delegate;

    // The load sequence is different if the delegate is set via IB or
    // programatically
    // In case of IB, delegate is set before the call to awakeFromNib
    // If done programatically in controller viewDidLoad, delegare is set after
    // the call to awakeFromNib
    if( initialized ) {
        [self loadBannerInView];    
    }
}


#pragma mark -
#pragma mark - Private methods

- (void)loadBannerInView {
    
    if( !ad4MaxDelegate ) {
        [self reportError:@"ERROR: you did not set any delegate for your ad4Max banner" withCode:Ad4MaxConfigurationError];
        return;
    }
    
    if( ![ad4MaxDelegate respondsToSelector:@selector(getAdBoxId)] ) {
        [self reportError:@"ERROR: your delegate for ad4Max banner does not implement mandatory method getAdBoxId" withCode:Ad4MaxConfigurationError];
        return;
    }
    
    // set web view content
    NSString *htmlStringFormat = @"<html><head><title></title><style type=\"text/css\">html, body { margin: 0; padding: 0; } </style></head><body><script type=\"text/javascript\">ad4max_guid = \"%@\";ad4max_app_name = \"%@\";ad4max_app_version = \"%@\";ad4max_uid = \"%@\";ad4max_lang = \"%@\";ad4max_connection_type = \"%@\";ad4max_width = \"%@\";ad4max_height = \"%@\";%@</script><script type=\"text/javascript\" src=\"http://max.medialution.com/ad4max.js\"></script></body></html>";

    NSString *guidString = [ad4MaxDelegate getAdBoxId];
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
        [optionalParamsString appendFormat:@"ad4max_carrier = \"%@\";", carrierNameString];
    }
    if([paramsService isFirstLaunch]) {
        [optionalParamsString appendFormat:@"ad4max_first_launch = \"1\";"];
    }
    
    // Handle optional delegate methods
    if ([ad4MaxDelegate respondsToSelector:@selector(forceLangFilter)] ) {
        if ([ad4MaxDelegate forceLangFilter]) {
            [optionalParamsString appendFormat:@"ad4max_lang_filter  = \"on\";"];
        } 
        else {
            [optionalParamsString appendFormat:@"ad4max_lang_filter  = \"off\";"];
        }
    }
    if ([ad4MaxDelegate respondsToSelector:@selector(getTargetedPublisherCategories)] ) {
        if ([ad4MaxDelegate getTargetedPublisherCategories]) {
            [optionalParamsString appendFormat:@"ad4max_publisher_categories  = \"%@\";", [ad4MaxDelegate getTargetedPublisherCategories]];
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
                                     optionalParamsString] autorelease];
    
    DLog(@"%@", generatedHTMLString);
    
    cntWebViewLoads = 0;
    bannerLoaded = NO;
    [activeWebView loadHTMLString:generatedHTMLString baseURL:nil];

    // Report event to delegate
    if ([ad4MaxDelegate respondsToSelector:@selector(bannerViewWillLoadAd:)] ) {
        [self.ad4MaxDelegate bannerViewWillLoadAd:self];
    }
        
    // Basic refresh functionality 
    // If application goes in backgroune, the timer will fire the next time 
    // the application becomes active, which is the expected behaviour
    if ([ad4MaxDelegate respondsToSelector:@selector(getAdRefreshRate)] ) {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:[ad4MaxDelegate getAdRefreshRate] target:self selector:@selector(changeAd) userInfo:nil repeats:NO];
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
    
    [UIView transitionFromView:inactiveWebView toView:activeWebView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    
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
        if( height != (int)self.frame.size.height || width != (int)self.frame.size.width ) {
            [self reportBannerSizeErrorWithHeight:height andWidth:width];
            return;
        }

        bannerLoaded = YES;

        if( [ad4MaxDelegate respondsToSelector:@selector(bannerViewDidLoadAd:)] )
            [self.ad4MaxDelegate bannerViewDidLoadAd:self];
    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)_error {

    // Do not decrement cntWebViewLoads to avoid having webViewDidFinishLoad
    // called    

    // Handle error
    if ([_error code] == -1009) {
        [self reportError:@"ERROR: unable to load a ad4Max banner, your Internet collection appears to be offline" withCode:Ad4MaxNetworkNotReachableError];    
    }
    else {
        [self reportError:[_error description] withCode:Ad4MaxUnknownError];
    }
}

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
