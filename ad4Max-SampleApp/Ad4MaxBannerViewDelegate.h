//
//
//  Ad4MaxBannerViewDelegate.h
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


#import "Ad4MaxBannerView.h"

#import <Foundation/Foundation.h>


@protocol Ad4MaxBannerViewDelegate <NSObject>

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
