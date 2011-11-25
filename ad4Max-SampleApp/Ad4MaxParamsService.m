//
//
//  Ad4MaxComputeParamsService.m
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


@interface Ad4MaxParamsService ()

@property(nonatomic, retain)	NSUserDefaults			*userDefaults; 

@end

@implementation Ad4MaxParamsService

@synthesize userDefaults;

#pragma mark -
#pragma mark Memory Management

- (id) init {
	
	if ((self = [super init]))
    {
		self.userDefaults = [[[NSUserDefaults alloc] init] autorelease];		
    }
	
	return self;
}

- (void) dealloc
{
	self.userDefaults = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Public methods for Ad4MaxBannerView

-(NSString*) getUID {
    return [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
}

-(NSString*) getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];    
}

-(NSString*) getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];    
}

-(NSString*) isFirstLaunch {
    
    BOOL firstLaunch = ![userDefaults boolForKey:@"ad4MaxAlreadyLaunched"];
    
    if( firstLaunch ) {
        [userDefaults setBool:YES forKey:@"ad4MaxAlreadyLaunched"];
        return @"1";
    }
    else {
        return @"0";    
    }
}

-(NSString*) getLang {
    return [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
}


@end
