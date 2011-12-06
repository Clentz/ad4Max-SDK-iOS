//
//  Ad4MaxBannerView.h
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


#import <UIKit/UIKit.h>

@protocol   Ad4MaxBannerViewDelegate;	
@class      Ad4MaxParamsService;

/**
 Ad4MaxBanner View
 */
@interface Ad4MaxBannerView : UIView <UIWebViewDelegate> {
        
   /**
        The webview containing the ad
    */
    UIWebView*					activeWebView;
    
    /**
        The next add in a non-visible webview
     */
    UIWebView*					inactiveWebView;
    
    /**
        The number of webview ad ready do display
     */
    NSInteger                   cntWebViewLoads;
    
    /**
        The service object used to retrieve the ad content
     */
    Ad4MaxParamsService*        paramsService;
    
    /**
        The timer runing to handle the refresh of the ad
     */
    NSTimer*                    refreshTimer;
    
   
}


/**
 The ad4MaxBannerView Delegate attribute
 */
@property(nonatomic, assign) IBOutlet id<Ad4MaxBannerViewDelegate> ad4MaxDelegate;

/**
 bannerLoaded atribute set to YES if the banner is fully loaded
 */
@property(readonly, assign) BOOL bannerLoaded;

@end
