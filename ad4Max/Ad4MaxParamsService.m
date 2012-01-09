//
//
//  Ad4MaxComputeParamsService.m
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

#import "Ad4MaxParamsService.h"
#import "Ad4MaxReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Ad4MaxUtilities.h"


@interface Ad4MaxParamsService ()

@end

@implementation Ad4MaxParamsService


#pragma mark -
#pragma mark Memory Management

- (void) dealloc
{
	[super dealloc];
}

#pragma mark -
#pragma mark Public methods for Ad4MaxBannerView

-(NSString*) getUID {
    return [Ad4MaxUtilities uniqueGlobalDeviceIdentifier];
}

-(NSString*) getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];    
}

-(NSString*) getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];    
}

-(BOOL) isFirstLaunch {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL firstLaunch = ![userDefaults boolForKey:@"ad4MaxAlreadyLaunched"];
    
    if( firstLaunch ) {
        [userDefaults setBool:YES forKey:@"ad4MaxAlreadyLaunched"];
        [userDefaults synchronize];
    }

    return firstLaunch;
}

-(NSString*) getLang {
    return [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
}

-(NSString*) getConnectionType {
    
    // returns wifi if not connected (not send to the server anyway)
    
    if( [[Ad4MaxReachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN ) {
        return @"edge";
    }
    else {
        return @"wifi";
    }
}

// Possibly not available on some
-(NSString*) getCarrierName {
    
    if( !NSClassFromString(@"CTTelephonyNetworkInfo") && !NSClassFromString(@"CTCarrier") ) {
        CTTelephonyNetworkInfo *netinfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        CTCarrier *carrier = [netinfo subscriberCellularProvider];
        return [[carrier carrierName] lowercaseString];
    }
    else {
        return nil;
    }
}

@end
