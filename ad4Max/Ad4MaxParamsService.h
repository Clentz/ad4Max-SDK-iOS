//
//
//  Ad4MaxComputeParamsService.h
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


#import <UIKit/UIKit.h>


@interface Ad4MaxParamsService : NSObject {

    NSUserDefaults	*userDefaults;  // persist the fact that application was already launched
}

// Available on all devices
-(NSString*) getUID;
-(NSString*) getAppName;
-(NSString*) getAppVersion;
-(BOOL) isFirstLaunch;
-(NSString*) getLang;
-(NSString*) getConnectionType;

// Possibly not available on some devices
-(NSString*) getCarrierName;

@end
