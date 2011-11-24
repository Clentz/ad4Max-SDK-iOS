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


#import "Ad4MaxBannerView.h"

@interface Ad4MaxBannerView ()

// Private properties and methods
@property (nonatomic, retain) UIWebView* webView;

- (void)baseInit;
- (void)loadBannerInView;

@end


@implementation Ad4MaxBannerView

@synthesize delegate;
@synthesize webView;

#pragma mark - Memory Management

- (void)dealloc
{
    self.delegate = nil;
    self.webView = nil;
    
    [super dealloc];
}

- (void)baseInit {
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,super.frame.size.width,super.frame.size.height)];
    [webView setDelegate:self];
    
    // add webView to View
    [self addSubview:webView];        

    [self loadBannerInView];
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

- (void)loadBannerInView {

// set web view content
NSString *htmlString = @"<html><head><title></title><style type=\"text/css\">html, body { margin: 0; padding: 0; } </style></head><body><script type=\"text/javascript\">/* 320x50, Advertisement #1 */ad4max_guid = \"b15dded7-8c97-456a-9395-c2ca6a7832d7\";ad4max_width = \"320\";ad4max_height = \"50\";</script><script type=\"text/javascript\" src=\"http://max.medialution.com/ad4max.js\"></script></body></html>";

[webView loadHTMLString:htmlString baseURL:nil];

}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad:");
}

@end
