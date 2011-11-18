//
//  ad4MaxMobile_SampleAppViewController.m
//  ad4MaxMobile-SampleApp
//
//  Created by Cyril Picat on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ad4MaxMobile_SampleAppViewController.h"

@implementation ad4MaxMobile_SampleAppViewController

@synthesize webView;

- (void)dealloc
{
    self.webView = nil;
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
}

- (void) viewWillAppear:(BOOL)animated {
		
	// set web view content
	NSString *htmlString = @"<html><head><title></title><style type=\"text/css\">html, body { margin: 0; padding: 0; } </style></head><body><script type=\"text/javascript\">/* 320x50, Advertisement #1 */ad4max_guid = \"b15dded7-8c97-456a-9395-c2ca6a7832d7\";ad4max_width = \"320\";ad4max_height = \"50\";</script><script type=\"text/javascript\" src=\"http://max.medialution.com/ad4max.js\"></script></body></html>";
    	
	[webView loadHTMLString:htmlString baseURL:nil];
	
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

@end
