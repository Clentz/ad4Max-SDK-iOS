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
    
    [super dealloc];
}

- (void)baseInit {
    
    self.paramsService = [[[Ad4MaxParamsService alloc] init] autorelease];
    
    self.inactiveWebView = nil;
    self.activeWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)] autorelease];
    [activeWebView setOpaque:NO]; 
    activeWebView.backgroundColor = [UIColor clearColor];
    [activeWebView setDelegate:self];
    
    // add webView to View
    [self addSubview:inactiveWebView];        
    [self addSubview:activeWebView];        

    // make sure the layout stays correct if the outer superview is resized
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self setOpaque:NO]; 
    self.backgroundColor = [UIColor clearColor];
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
    [self loadBannerInView];
}


#pragma mark -
#pragma mark - Private methods

- (void)loadBannerInView {

    // set web view content
    NSString *htmlStringFormat = @"<html><head><title></title><style type=\"text/css\">html, body { margin: 0; padding: 0; } </style></head><body><script type=\"text/javascript\">ad4max_guid = \"%@\";ad4max_app_name = \"%@\";ad4max_app_version = \"%@\";ad4max_uid = \"%@\";ad4max_first_launch = \"%@\";ad4max_lang = \"%@\";ad4max_connection_type = \"%@\";ad4max_width = \"%@\";ad4max_height = \"%@\";%@</script><script type=\"text/javascript\" src=\"http://max.medialution.com/ad4max.js\"></script></body></html>";

    NSString *guidString = [ad4MaxDelegate getAdBoxId];
    NSString *widthString = [NSString stringWithFormat: @"%.0f", super.frame.size.width];
    NSString *heightString = [NSString stringWithFormat: @"%.0f", super.frame.size.height];
    
    NSString *uidString = [paramsService getUID];
    NSString *appNameString = [paramsService getAppName];
    NSString *appVersionString = [paramsService getAppVersion];
    NSString *firstLaunchString = [paramsService isFirstLaunch];
    NSString *langString = [paramsService getLang];
    NSString *connectionTypeString = [paramsService getConnectionType];
    
    
    // Handle optional parameters
    NSMutableString *optionalParamsString = [[[NSMutableString alloc] init] autorelease];
    NSString *carrierNameString = [paramsService getCarrierName];
    if(carrierNameString) {
        [optionalParamsString appendFormat:@"ad4max_carrier = \"%@\"", carrierNameString];
    }
        
    NSString *generatedHTMLString = [[[NSString alloc] initWithFormat:htmlStringFormat, 
                                     guidString, 
                                     appNameString,
                                     appVersionString,
                                     uidString,
                                     firstLaunchString,
                                     langString,
                                     connectionTypeString,
                                     widthString, 
                                     heightString, 
                                     optionalParamsString] autorelease];
    
    NSLog(@"%@", generatedHTMLString);
    
    [activeWebView loadHTMLString:generatedHTMLString baseURL:nil];

    // Basic refresh functionality  
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(changeAd) userInfo:nil repeats:NO];

}

- (void)changeAd {

    self.inactiveWebView = activeWebView;
    [inactiveWebView stopLoading];
    
    self.activeWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)] autorelease];
    [activeWebView setOpaque:NO]; 
    activeWebView.backgroundColor = [UIColor clearColor];
    [activeWebView setDelegate:self];

    [self loadBannerInView];
}

#pragma mark -
#pragma mark - UIWebViewDelegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
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
}

@end
