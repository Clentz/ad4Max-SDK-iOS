//
//  ad4MaxMobile_SampleAppViewController.h
//  ad4MaxMobile-SampleApp
//
//  Created by Cyril Picat on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ad4MaxBannerViewDelegate.h"

#import <UIKit/UIKit.h>

@interface ad4Max_SampleAppViewController : UIViewController <Ad4MaxBannerViewDelegate> {
    
    IBOutlet Ad4MaxBannerView *bannerView;
}

@property (nonatomic, retain) IBOutlet Ad4MaxBannerView *bannerView;

@end
