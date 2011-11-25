//
//
//  ad4Max_SampleAppViewController.h
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


#import "Ad4MaxBannerViewDelegate.h"

#import <UIKit/UIKit.h>

@interface ad4Max_SampleAppViewController : UIViewController <Ad4MaxBannerViewDelegate, UITextFieldDelegate> {
    
    
    IBOutlet Ad4MaxBannerView *bannerView;
    
    
    // Outlets used to exhibit configuration possibilities
	IBOutlet UIScrollView	*scrollView;

    IBOutlet UITextField    *adBoxIdTextField;
    IBOutlet UITextField    *refreshRateTextField;
    IBOutlet UITextField    *categoriesTextField;
    
    IBOutlet UISwitch       *refreshSwitch;
    IBOutlet UISwitch       *forceLangSwitch;
    
    UITapGestureRecognizer	*singleTap;	
	UITextField				*lastActiveField;		// active UITextField
	CGSize					keyboardSize;			// size of keyboard displayed
}

@property (nonatomic, retain) IBOutlet Ad4MaxBannerView *bannerView;

@property (nonatomic, retain) IBOutlet UIScrollView	*scrollView;;
@property (nonatomic, retain) IBOutlet UITextField *adBoxIdTextField;
@property (nonatomic, retain) IBOutlet UITextField *refreshRateTextField;
@property (nonatomic, retain) IBOutlet UITextField *categoriesTextField;
@property (nonatomic, retain) IBOutlet UISwitch *refreshSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *forceLangSwitch;
@property (nonatomic, retain) UITapGestureRecognizer *singleTap;

- (void) hideKeyboard;
- (void) resizeAndScrollView;

@end
