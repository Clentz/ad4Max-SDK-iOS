//
//  ad4MaxMobile_SampleAppAppDelegate.h
//  ad4MaxMobile-SampleApp
//
//  Created by Cyril Picat on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ad4MaxMobile_SampleAppViewController;

@interface ad4MaxMobile_SampleAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ad4MaxMobile_SampleAppViewController *viewController;

@end
