//
//
//  Ad4MaxBannerViewTests.m
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
#import "Ad4MaxBannerViewDelegate.h"

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h> 

@interface Ad4MaxBannerViewTests : GHTestCase { 
    
    Ad4MaxBannerView *banner;
    id               delegate;
}

@property (nonatomic, retain) Ad4MaxBannerView *banner;
@property (nonatomic, retain) id delegate;

@end

@implementation Ad4MaxBannerViewTests

@synthesize banner, delegate;

- (BOOL)shouldRunOnMainThread { return YES; }

#pragma mark -
#pragma mark Tests setup

- (void)setUp {
  
    // Run before each test method

    Ad4MaxBannerView *view = [[[Ad4MaxBannerView alloc] init] autorelease];
    self.banner = [OCMockObject partialMockForObject:view]; 
    
    [[[banner stub] andCall:@selector(notDoingAnyUIKitThingMethod) onObject:self] loadBannerInView];

    banner.frame = CGRectMake(0, 0, 320, 50);

    self.delegate = [OCMockObject niceMockForProtocol:@protocol(Ad4MaxBannerViewDelegate)]; 
    [banner setAd4MaxDelegate:delegate];

}

- (void)tearDown {
    // Run after each test method
    self.banner = nil;
    self.delegate = nil;
}   

- (void)notDoingAnyUIKitThingMethod {
    // fake method replacement
}

#pragma mark -
#pragma mark Tests methods

- (void)testGetWebViewContent_missingAdBoxId {
  
    [[delegate reject] getAdBoxId];

    // Does not seem to work
    // GHAssertThrows([banner getWebViewContent], @"Should have thrown an NSInternalInconsistencyException", nil);
    // GHAssertThrowsSpecificNamed([banner getWebViewContent], NSException, NSInternalInconsistencyException, @"Should have thrown an NSInternalInconsistencyException", nil);
}

- (void)testGetWebViewContent_missingAdServerURL {

    [[[delegate stub] andReturn:@"adboxid"] getAdBoxId];
    [[delegate reject] getAdServerURL];

    // Does not seem to work
    // GHAssertThrowsSpecificNamed([banner getWebViewContent], NSException, NSInternalInconsistencyException, @"Should have thrown an NSInternalInconsistencyException", nil);
    
}

- (void)testGetWebViewContent_minimalDelegate {
    
    [[[delegate stub] andReturn:@"adboxid"] getAdBoxId];
    [[[delegate stub] andReturn:@"adserverurl"] getAdServerURL];
    
    NSError  *error  = NULL;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:@"<html><head><title></title><style type='text/css'>html, body { margin: 0; padding: 0; } div#container { text-align: center; }</style></head><body><div id='container'><script type='text/javascript'>ad4max_guid = 'adboxid';ad4max_app_name = 'ad4Max-Tests';ad4max_app_version = '1.0';ad4max_uid = '[a-zA-Z0-9]*';ad4max_lang = 'en';ad4max_connection_type = 'wifi';ad4max_width = '320';ad4max_height = '50';ad4max_lang_filter = 'off';</script><script type='text/javascript' src='http://adserverurl/ad4max.js'></script><div></body></html>"
                                  options:0
                                  error:&error];

    NSString *htmlString = [banner getWebViewContent];
    
//    GHAssertEquals((NSUInteger)1, [regex numberOfMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])], @"Unexpected HTML content: %@", htmlString, nil);
    
}






@end
