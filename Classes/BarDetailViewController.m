//
//  BarDetailViewController.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/31/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarDetailViewController.h"


@implementation BarDetailViewController
@synthesize bar;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[nameField setText:[bar name]];
	[addrField setText:[bar addr]];
	[cityField setText:[bar city]];
	[stateField setText:[bar state]];
	[zipField setText:[bar zip]];
	
	// Change the navigation item to display the name of possession.
	[[self navigationItem] setTitle:[bar name]];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// Clear first responder
	[nameField resignFirstResponder];
	[addrField resignFirstResponder];
	[cityField resignFirstResponder];
	[stateField resignFirstResponder];
	[zipField resignFirstResponder];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[nameField release];
	nameField = nil;
	
	[nameField release];
	nameField = nil;
	
	[addrField release];
	addrField = nil;
	
	[cityField release];
	cityField = nil;
	
	[stateField release];
	stateField = nil;
	
	[zipField release];
	zipField = nil;
}


- (void)dealloc {
	[nameField release];
	[addrField release];
	[cityField release];
	[stateField release];
	[zipField release];
	
    [super dealloc];
}


@end
