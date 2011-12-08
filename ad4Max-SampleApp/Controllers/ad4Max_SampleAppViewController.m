//
//
//  ad4Max_SampleAppViewController.m
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


#import "ad4Max_SampleAppViewController.h"

@implementation ad4Max_SampleAppViewController

@synthesize bannerView;
@synthesize scrollView , navBar, tabBar, adBoxIdTextField, adServerUrlTextField,refreshRateTextField, categoriesTextField, refreshSwitch, forceLangSwitch, disableClickSwitch, positionControl, singleTap;

- (void)dealloc
{
    self.bannerView = nil;
    
    self.scrollView = nil;
    self.navBar = nil;
    self.tabBar = nil;
    self.adBoxIdTextField = nil;
    self.adServerUrlTextField = nil;
    self.refreshRateTextField = nil;
    self.categoriesTextField = nil;
    self.refreshSwitch = nil;
    self.forceLangSwitch = nil;
    self.disableClickSwitch = nil;
    self.positionControl = nil;
    self.singleTap = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    // Set content size for scroll view
    scrollView.contentSize = CGSizeMake(0, scrollView.frame.size.height);
    scrollView.clipsToBounds = YES;

    [positionControl addTarget:self
                        action:@selector(positionControlChanged)
              forControlEvents:UIControlEventValueChanged];

    // detect single touch on a UIScrollView
	self.singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {

    // Register the observer for the keyboardWillShow, keyboardWillBeHidden events
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    // Return YES for supported orientations
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (void)positionControlChanged {
    
    CGFloat screenHeight = [self.view bounds].size.height;
    CGFloat screenWidth = [self.view bounds].size.width;
    
    switch (positionControl.selectedSegmentIndex) {
        case 0:
            // Top position, instead of NavBar
            navBar.hidden = YES;
            tabBar.hidden = NO;
            [bannerView setFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];  
            [scrollView setFrame:CGRectMake(0, bannerView.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height)];
            break;
        case 1:
            // Bottom position, instead of TabBar
            navBar.hidden = NO;
            tabBar.hidden = YES;
            [bannerView setFrame:CGRectMake(0, screenHeight-bannerView.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];                        
            [scrollView setFrame:CGRectMake(0, navBar.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height)];
            break;
        case 2:
            // Bottom position, above TabBar
            navBar.hidden = YES;
            tabBar.hidden = NO;
            [bannerView setFrame:CGRectMake(0, screenHeight-bannerView.frame.size.height-tabBar.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];                        
            [scrollView setFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
            break;
        case 3:
            // Top position, below NavBar
            navBar.hidden = NO;
            tabBar.hidden = YES;
            [bannerView setFrame:CGRectMake(0, navBar.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];                        
            [scrollView setFrame:CGRectMake(0, navBar.frame.size.height+bannerView.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height)];
            break;
    }
}

#pragma mark - Ad4MaxBannerViewDelegate

// Getting mandatory parameters
- (NSString*)getAdBoxId
{
    return adBoxIdTextField.text;
}

- (NSString*)getAdServerURL {
    return adServerUrlTextField.text;
}


// Optional methods
- (NSUInteger)getAdRefreshRate {
    if( [refreshSwitch isOn] ) {
        return [refreshRateTextField.text intValue];
    }
    else {
        return (NSUInteger)0;
    }
}

- (NSString*)getTargetedPublisherCategories {
    return categoriesTextField.text;
}

- (BOOL)forceLangFilter {
    return forceLangSwitch.isOn;
}

// Detecting When Advertisements Are Loaded
- (void)bannerViewWillLoadAd:(Ad4MaxBannerView *)banner
{
    NSLog(@"bannerViewWillLoadAd:");
}

- (void)bannerViewDidLoadAd:(Ad4MaxBannerView *)banner 
{
    NSLog(@"bannerViewDidLoadAd:");
}

// Detecting When a User Interacts With an Advertisement
- (BOOL)bannerViewActionShouldBegin:(Ad4MaxBannerView *)banner willLeaveApplication:(BOOL)willLeave 
{
    NSLog(@"bannerViewActionShouldBegin:willLeaveApplication: %@", (willLeave ? @"YES" : @"NO"));
    
    if( disableClickSwitch.isOn )
        return NO;
    else
        return YES;
}

// Detecting errors
- (void)bannerView:(Ad4MaxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error 
{
    NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error description]);    
}


#pragma mark - Handle of user input

- (void) hideKeyboard {	
	[lastActiveField resignFirstResponder];
}

// Called when the UIKeyboardDidShowNotification is sent
- (void)keyboardWillShow:(NSNotification *)notification {
	
	// Resize ScrollView and slide to selected UITextView
	NSDictionary* info = [notification userInfo];
	
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	[self resizeAndScrollView];	
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
	
	keyboardSize.height = 0.0;
	keyboardSize.width = 0.0;	
	
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) resizeAndScrollView {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
	
    // If active text field is hidden by keyboard, scroll it so it's visible	
    CGRect aRect = self.view.frame;
    aRect.size.height -= 44; // nav bar
    aRect.size.height -= keyboardSize.height;
	CGFloat currentOffset = [scrollView contentOffset].y;
	
	CGPoint topTextFieldPoint = CGPointMake(0.0, lastActiveField.frame.origin.y-currentOffset);
	CGPoint bottomTextFieldPoint = CGPointMake(0.0, lastActiveField.frame.origin.y+lastActiveField.frame.size.height-currentOffset);
    
	if (!CGRectContainsPoint(aRect, bottomTextFieldPoint)) {
		CGPoint scrollPoint = CGPointMake(0.0, lastActiveField.frame.origin.y+lastActiveField.frame.size.height-keyboardSize.height+20);
        [scrollView setContentOffset:scrollPoint animated:YES];
	}
	else if (!CGRectContainsPoint(aRect, topTextFieldPoint)) {
		CGPoint scrollPoint = CGPointMake(0.0, lastActiveField.frame.origin.y-20);
        [scrollView setContentOffset:scrollPoint animated:YES];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    lastActiveField = textField;	
	
	// in case you jump from field to field
	[self resizeAndScrollView];
	
	[scrollView addGestureRecognizer:singleTap];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[scrollView removeGestureRecognizer:singleTap];
}

@end
