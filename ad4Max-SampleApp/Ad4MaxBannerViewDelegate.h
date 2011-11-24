//
//  Ad4MaxBannerDelegate.h
//  ad4Max-SampleApp
//
//  Created by Cyril Picat on 11/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Ad4MaxBannerView.h"

#import <Foundation/Foundation.h>


@protocol Ad4MaxBannerViewDelegate 

// Getting mandatory parameters
- (NSString*)getAdBoxId;

// Detecting When Advertisements Are Loaded
- (void)bannerViewWillLoadAd:(Ad4MaxBannerView *)banner;
- (void)bannerViewDidLoadAd:(Ad4MaxBannerView *)banner;

// Detecting When a User Interacts With an Advertisement
- (BOOL)bannerViewActionShouldBegin:(Ad4MaxBannerView *)banner willLeaveApplication:(BOOL)willLeave;

// Detecting errors
- (void)bannerView:(Ad4MaxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;

@optional
// Getting optional parameters
- (NSUInteger)getAdRefreshRate;
- (NSString*)getTargetedPublisherCategories;
- (BOOL)forceLangFilter;


@end
