//
//  Ad4MaxBanner.h
//  ad4Max-SampleApp
//
//  Created by Cyril Picat on 11/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Ad4MaxBannerDelegate;	

@interface Ad4MaxBannerView : UIView <UIWebViewDelegate> {
        
    // Ad4MaxBannerDelegate
    id<Ad4MaxBannerDelegate>    delegate;

    UIWebView*					webView;
}

@property(nonatomic, assign) id<Ad4MaxBannerDelegate> delegate;

@end
