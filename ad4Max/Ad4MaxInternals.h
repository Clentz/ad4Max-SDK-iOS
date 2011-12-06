//
//  Ad4MaxInternals.h
//  ad4Max-SampleApp
//
//  Created by Thibaut LE LEVIER on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#    define ad4MaxLog(...) NSLog(__VA_ARGS__)
#else
#    define ad4MaxLog(...) /* */
#endif
#define ad4MaxALog(...) NSLog(__VA_ARGS__)