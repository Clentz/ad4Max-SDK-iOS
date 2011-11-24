//
//  ad4MaxMobile_SampleAppViewController.m
//  ad4MaxMobile-SampleApp
//
//  Created by Cyril Picat on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ad4Max_SampleAppViewController.h"

@implementation ad4Max_SampleAppViewController

@synthesize bannerView;

- (void)dealloc
{
    self.bannerView = nil;
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
    
    // set delegate for Ad banner
    [bannerView setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
			
	[super viewWillAppear:animated];
}	

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Ad4MaxBannerViewDelegate

// Getting mandatory parameters
- (NSString*)getAdBoxId
{
    return @"b15dded7-8c97-456a-9395-c2ca6a7832d7";
}

// Detecting When Advertisements Are Loaded
- (void)bannerViewWillLoadAd:(Ad4MaxBannerView *)banner
{
    // TODO: log it in a view in the Sample App
    NSLog(@"bannerViewWillLoadAd:");
}

- (void)bannerViewDidLoadAd:(Ad4MaxBannerView *)banner 
{
    // TODO: log it in a view in the Sample App
    NSLog(@"bannerViewDidLoadAd:");

}

// Detecting When a User Interacts With an Advertisement
- (BOOL)bannerViewActionShouldBegin:(Ad4MaxBannerView *)banner willLeaveApplication:(BOOL)willLeave 
{
    // TODO: log it in a view in the Sample App
    NSLog(@"bannerViewActionShouldBegin:willLeaveApplication:");
    return YES;
}

// Detecting errors
- (void)bannerView:(Ad4MaxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error 
{
    // TODO: log it in a view in the Sample App
    NSLog(@"bannerView:didFailToReceiveAdWithError:");    
}


@end
