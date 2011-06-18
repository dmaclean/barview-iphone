//
//  CurrentLocation.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "CurrentLocation.h"
#import "MapPoint.h"


@implementation CurrentLocation

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		UITabBarItem *tbi = [self tabBarItem];
		[tbi setTitle:@"Current Location"];
		
		/*
		 * Set up the location manager
		 */
		locationManager = [[CLLocationManager alloc] init];
		[locationManager setDelegate:self];
		[locationManager setDistanceFilter:kCLDistanceFilterNone];
		[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"Executing viewDidLoad");
    [super viewDidLoad];
	
	[locationManager startUpdatingLocation];
	[mapView setShowsUserLocation:YES];
	[mapView setZoomEnabled:YES];
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
	
	[locationManager stopUpdatingLocation];
}


- (void)dealloc {
    [super dealloc];
}

- (void) mapView: (MKMapView*) mv didAddAnnotationViews:(NSArray *) views {
	NSLog(@"in didAddAnnotationViews");
	
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	
	id <MKAnnotation> mp = [annotationView annotation];
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 250, 250);
	
	[mv setRegion:region animated:YES];
}

- (void)	locationManager:(CLLocationManager *)manager 
	 didUpdateToLocation:(CLLocation *)newLocation	
			fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%@", newLocation);
	
	// How many seconds ago was this new location created?
	NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
	
	// CLLocationManagers will return the last found location of the
	// device first, you don't want the data in this case.
	// If this location was made more than 3 minutes ago, ignore it.
	if (t < -180) {
		// This is cached data, we don't want it.
		return;
	}
	
	MapPoint *mp = [[MapPoint alloc] initWithCoordinate:[newLocation coordinate] title:@"piss"];
	[mapView addAnnotation:mp];
	[mp release];
	
	//[self foundLocation];
}

@end
