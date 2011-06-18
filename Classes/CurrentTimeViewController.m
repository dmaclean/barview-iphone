//
//  CurrentTimeViewController.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "CurrentTimeViewController.h"


@implementation CurrentTimeViewController

- (id) init {
	[super initWithNibName:nil bundle:nil];
	
	UITabBarItem *tbi = [self tabBarItem];
	
	[tbi setTitle:@"Time"];
	
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
    NSLog(@"Must have gotten a Low Memory.  Releasing timeLabel");
	
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[timeLabel release] ;
	timeLabel = nil; 
}

- (IBAction) showCurrentTime:(id) sender {
	NSDate *now = [NSDate date];
	static NSDateFormatter *formatter = nil;
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	}
	
	[timeLabel setText:[formatter stringFromDate:now]];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self showCurrentTime:nil];
}


- (void)dealloc {
	[timeLabel release];
    [super dealloc];
}


@end
