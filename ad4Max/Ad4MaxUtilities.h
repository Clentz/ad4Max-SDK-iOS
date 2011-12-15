//
//  Ad4MaxUtilities.h
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

//  This product includes software developed by the Georg Kitz.
//
//  Copyright (c) 2011, Georg Kitz
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. All advertising materials mentioning features or use of this software
//  must display the following acknowledgement:
//  This product includes software developed by the Georg Kitz.
//  4. Neither the name of the Georg Kitz nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.

// ============================================================================


#import <Foundation/Foundation.h>

@interface Ad4MaxUtilities : NSObject

+ (NSString *) MD5HashFromString:(NSString*)originalString;


+ (NSString *) macaddress;
+ (NSString *) uniqueDeviceIdentifier;
+ (NSString *) uniqueGlobalDeviceIdentifier;

@end
