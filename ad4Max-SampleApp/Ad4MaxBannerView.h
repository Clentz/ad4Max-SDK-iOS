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


#import <Foundation/Foundation.h>

@protocol   Ad4MaxBannerViewDelegate;	
@class      Ad4MaxParamsService;

@interface Ad4MaxBannerView : UIView <UIWebViewDelegate> {
        
    // Ad4MaxBannerDelegate
    IBOutlet id<Ad4MaxBannerViewDelegate>    ad4MaxDelegate;

    // Private members
    BOOL                        initialized;
    UIWebView*					activeWebView;
    UIWebView*					inactiveWebView;
    Ad4MaxParamsService*        paramsService;
    NSTimer*                    refreshTimer;
}

@property(nonatomic, assign) IBOutlet id<Ad4MaxBannerViewDelegate> ad4MaxDelegate;

@end
