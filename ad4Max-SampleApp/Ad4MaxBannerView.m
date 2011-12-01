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

@end


@implementation Ad4MaxBannerView

@synthesize ad4MaxDelegate;
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
    [self addSubview:inactiveWebView];        
    [self addSubview:activeWebView];        
    
    // make sure the layout stays correct if the outer superview is resized
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self setOpaque:NO]; 
    self.backgroundColor = [UIColor clearColor];

    initialized = YES;
    
    [self loadBannerInView];        
}

- (void)initActiveWebView {
 
    self.activeWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)] autorelease];
    UIScrollView *scrollView = [[activeWebView subviews] lastObject];
    scrollView = NO;
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

    // The load sequence is different if the delegate is set via IB or programatically
    // In case of IB, delegate is set before the call to awakeFromNib
    // If done programatically in controller viewDidLoad, delegare is set after the call to awakeFromNib
    if( initialized ) {
        [self loadBannerInView];    
    }
}


#pragma mark -
#pragma mark - Private methods

- (void)loadBannerInView {

    NSLog(@"delegate %@", ad4MaxDelegate);
    NSLog(@"service %@", paramsService);
    
    if( !ad4MaxDelegate ) {
        // TODO add an error
        NSLog(@"ERROR: you did not set any delegate for ad4max banner %@", self);
        return;
    }
    else if( ![ad4MaxDelegate respondsToSelector:@selector(getAdBoxId)] ) {
        // TODO add an error
        NSLog(@"ERROR: your delegate for ad4amx banner %@ does not implement mandatory method getAdBoxId", self);        
        return;
    }

    // Test Banner is visible
    if( [self.superview.subviews lastObject] != self ) {
        // TODO add an error
        NSLog(@"ERROR: ad4Max banner for AD BOX ID %@ is not visible", [ad4MaxDelegate getAdBoxId]);
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
    
    [activeWebView loadHTMLString:generatedHTMLString baseURL:nil];

    // Report event to delegate
    [self.ad4MaxDelegate bannerViewWillLoadAd:self];

    // Basic refresh functionality  
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
        if( [self.ad4MaxDelegate bannerViewActionShouldBegin:self willLeaveApplication:YES] ) {
            [[UIApplication sharedApplication] openURL:[inRequest URL]];        
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    
    // Below assumes you have two subviews that you're trying to transition between
    [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView commitAnimations];

    // Report event to delegate
    [self.ad4MaxDelegate bannerViewDidLoadAd:self];
}

@end
