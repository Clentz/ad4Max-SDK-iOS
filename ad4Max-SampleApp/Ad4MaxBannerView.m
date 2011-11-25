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
#import "Ad4MaxBannerView.h"

@interface Ad4MaxBannerView ()

// Private properties and methods
@property (nonatomic, retain) UIWebView* webView;

- (void)baseInit;
- (void)loadBannerInView;

@end


@implementation Ad4MaxBannerView

@synthesize ad4MaxDelegate;
@synthesize webView;

#pragma mark -
#pragma mark - Memory Management

- (void)dealloc
{
    self.ad4MaxDelegate = nil;
    self.webView = nil;
    
    [super dealloc];
}

- (void)baseInit {
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)];
    [webView setDelegate:self];
    
    // add webView to View
    [self addSubview:webView];        

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
    NSString *htmlStringFormat = @"<html><head><title></title><style type=\"text/css\">html, body { margin: 0; padding: 0; } </style></head><body><script type=\"text/javascript\">ad4max_guid = \"%@\";ad4max_width = \"%@\";ad4max_height = \"%@\";%@</script><script type=\"text/javascript\" src=\"http://max.medialution.com/ad4max.js\"></script></body></html>";

    NSString *guidString = [ad4MaxDelegate getAdBoxId];
    NSString *widthString = @"320";
    NSString *heightString = @"50";  
    NSString *optionalParamsString = @"";
    
    NSString *generatedHTMLString = [[NSString alloc] initWithFormat:htmlStringFormat, guidString, widthString, heightString, optionalParamsString];
    
    NSLog(generatedHTMLString);
    
    [webView loadHTMLString:generatedHTMLString baseURL:nil];

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

@end
