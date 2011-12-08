//
//  Ad4MaxUtilities.h
//  ad4Max-SampleApp
//
//  Created by Thibaut LE LEVIER on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ad4MaxUtilities : NSObject

+ (NSString *) MD5HashFromString:(NSString*)originalString;


+ (NSString *) macaddress;
+ (NSString *) uniqueDeviceIdentifier;
+ (NSString *) uniqueGlobalDeviceIdentifier;

@end
