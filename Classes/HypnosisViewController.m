    //
//  HypnosisViewController.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"


@implementation HypnosisViewController

- (id) init {
	// Call the superclass' designated initializer
	[super initWithNibName:nil bundle:nil];
	
	// Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle:@"Hypnosis"];
	
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //if (self) {
        // Custom initialization.
    //}
    return [self init];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	HypnosisView *hv = [[HypnosisView alloc] initWithFrame:CGRectZero];
	[hv setBackgroundColor:[UIColor whiteColor]];
	[self setView:hv];
	[hv release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
}


- (void)dealloc {
    [super dealloc];
}


@end
