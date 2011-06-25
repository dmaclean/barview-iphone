//
//  BarMapLookup.m
//  Hypnotime
//
//  Created by Dan MacLean on 6/1/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarMapLookup.h"


@implementation BarMapLookup

@synthesize data, connection;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		[[self tabBarItem] setTitle:@"Search Bars"];
        
        annotations = [[NSMutableArray alloc] init];
		
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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[self.connection cancel];
	
	self.connection = nil;
	self.data = nil;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	// Put data retrieved into data structure
	NSMutableData* d = [[NSMutableData alloc] init];
	self.data = d;
	
	[mapView setShowsUserLocation:YES];
	[locationManager startUpdatingLocation];
}

- (void) mapView:(MKMapView*) mv didAddAnnotationViews:(NSArray*) views {
	NSLog(@"in didAddAnnotationViews");
	
	MKAnnotationView *annotationView = [views objectAtIndex:[views count]-1];
	
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
    [annotations addObject:mp];
	[mapView addAnnotations:annotations];
	[mp release];
	
	[locationManager stopUpdatingLocation];
}

/*
 * Sends a request to Google's geocoding API to get the coordinates for the
 * address provided in the location field.
 *
 * The coordinates are collected in the callback function connectionDidFinishLoading.
 */
- (void) getMapCoordinates:(NSString*) address {
	NSString* geocodingURL = @"http://maps.google.com/maps/geo?q=%@&output=%@";
	
	NSString* finalURL = [NSString stringWithFormat:geocodingURL, address, GOOGLE_OUPUT_FORMAT_CSV];
	finalURL = [finalURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// Create the URL and request to connect to URL.
	NSURL* urlToCall = [NSURL URLWithString:finalURL];
	NSURLRequest* request = [NSURLRequest requestWithURL:urlToCall];
	
	// Create connection to get data
    if(connection) {
        [connection cancel];
        [connection release];
    }
    
	NSURLConnection* c = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = c;
	[c release];
}

/*
 * When we get data back from the HTTP request we want to reset the data structure.
 */
- (void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse*) response {
	[data setLength:0];
}

/*
 * Append the data we receive to our data structure.
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
	[data appendData:d];
}

/*
 * Perform logging and error handling when an error occurs with the URL connection.
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
	NSLog(@"Connection error happened.");
    
    [self.connection release];
    self.connection = nil;
}

/*
 * The callback function that handles the results of requests to the Google geocoding API.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString* connectionString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if ([connectionString length] > 0) {
		NSArray* components = [connectionString componentsSeparatedByString:@","];
		
		NSString	*statusCode = nil,
					*accuracy = nil,
					*lat = nil,
					*lon = nil;
		
		if ([components count] == 4) {
			statusCode = [components objectAtIndex:0];
			accuracy = [components objectAtIndex:1];
			lat = [components objectAtIndex:2];
			lon = [components objectAtIndex:3];
			
			NSLog(@"Status code: %@", statusCode);
			NSLog(@"Accuracy: %@", accuracy);
			NSLog(@"Latitude: %@", lat);
			NSLog(@"Longitude: %@", lon);
            
            [mapView removeAnnotations:annotations];
            [annotations removeAllObjects];
            
            CLLocationCoordinate2D loc;
            loc.latitude = [lat floatValue];
            loc.longitude = [lon floatValue];
            MapPoint *mp = [[MapPoint alloc] initWithCoordinate:loc title:@"New Annotation"];
            [mapView addAnnotation:mp];
            [annotations addObject:mp];
            
            MKMapPoint annotationPoint = MKMapPointForCoordinate([mp coordinate]);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            
            mapView.visibleMapRect = pointRect;
            
            [mp release];
		}
	}
	else {
		NSLog(@"String is empty.  What the fuck happened?");
	}
    
    

}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"IN HERE!!!");
    NSLog(@"Number of annotations %d", [annotations count]);
    
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField*) tf {
	NSLog(@"textFieldShouldReturn");
	[self getMapCoordinates:[locationField text]];
	[tf resignFirstResponder];
	return YES;
}


- (void)dealloc {
	[connection cancel];
	[connection release];
    connection = nil;
	
	[data release];
	
    [super dealloc];
}


@end
