//
//
//  Ad4MaxParamsServiceTests.m
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


#import "Ad4MaxParamsService.h"

#import <GHUnitIOS/GHUnit.h> 

@interface Ad4MaxParamsServiceTests : GHTestCase { 

    Ad4MaxParamsService *service;
}

@property (nonatomic, retain) Ad4MaxParamsService *service;

@end

@implementation Ad4MaxParamsServiceTests

@synthesize service;

#pragma mark -
#pragma mark Tests setup

- (void)setUpClass {
    // Run at start of all tests in the class
    self.service = [[[Ad4MaxParamsService alloc] init] autorelease];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    self.service = nil;
}


#pragma mark -
#pragma mark Tests methods

- (void)testGetAppName {
    GHAssertEqualStrings(@"ad4Max-Tests", [service getAppName], @"App name");
}

- (void)testGetAppVersion {
    GHAssertEqualStrings(@"1.0", [service getAppVersion], @"App version");
}

- (void)testGetLang {
    GHAssertEqualStrings(@"en", [service getLang], @"User language");
}

- (void)testIsFirstLaunch_firstLaunch { 
    
    NSUserDefaults *userDefaults = [[[NSUserDefaults alloc] init] autorelease];
    [userDefaults setBool:NO forKey:@"ad4MaxAlreadyLaunched"];
    
    GHAssertTrue([service isFirstLaunch], @"isFirstLaunch should be YES");        
}

- (void)testIsFirstLaunch_notFirstLaunch { 
        
    GHAssertFalse([service isFirstLaunch], @"isFirstLaunch should be NO");        
}

- (void)testGetUID {
    
    NSString *uid = [service getUID];
    GHAssertEqualStrings(uid, [service getUID], @"UID should be constant");
    GHAssertEqualStrings(uid, [service getUID], @"UID should be constant");
}

- (void)testConnectionType {
    
    GHAssertEqualStrings(@"wifi", [service getConnectionType], @"No possible to be on edge in simulator");    
}

- (void)testCarrierName {
    
    GHAssertNil([service getCarrierName], @"No carrier on simulator");   
}



@end
