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
@synthesize nearbyBarConnection, nearbyBarData;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        [[self navigationItem] setTitle:@"Current Location"];
		
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

/**
 * Set the navigation bar to be hidden when showing the map.
 */
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)dealloc {
    [super dealloc];
}

- (void) mapView: (MKMapView*) mv didAddAnnotationViews:(NSArray *) views {
	NSLog(@"in didAddAnnotationViews");
	
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	
	id <MKAnnotation> mp = [annotationView annotation];
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 500, 500);
	
	[mv setRegion:region animated:YES];
}

/**
 * Configure an annotation that will appear within the view.  We want each annotation to
 * have the current image from its respective bar.  Might revisit this approach later depending
 * on how painful it is on the database.
 */
- (MKAnnotationView*) mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"Inside of viewForAnnotation");
    
    // We don't want to go through all this nonsense if the annotation is for the
    // user's location (blue dot).  The reason this worked in BarMapLookup is because
    // this method wasn't implemented.
    if ([annotation isMemberOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MapPoint* myAnnotation = (MapPoint*) annotation;
    
    //MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    MapPointView *annotationView = (MapPointView*)[mv dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
        annotationView = [[[MapPointView alloc] initWithAnnotation:myAnnotation reuseIdentifier:AnnotationViewID] autorelease];
    
    // Set the bar id and name (this may have already been done on init)
    [annotationView setBarId:[myAnnotation barId]];
    [annotationView setBarName:[myAnnotation title]];
    
    annotationView.pinColor = MKPinAnnotationColorPurple;
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}

- (void)	locationManager:(CLLocationManager *)manager 
	 didUpdateToLocation:(CLLocation *)newLocation	
			fromLocation:(CLLocation *)oldLocation {

	NSLog(@"didUpdateToLocation - %@", newLocation);
	
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
	
    CLLocationCoordinate2D loc = [newLocation coordinate];
    NSString* lat = [[NSString alloc] initWithFormat:@"%f", loc.latitude];
    NSString* lng = [[NSString alloc] initWithFormat:@"%f", loc.longitude];
    [self fetchNearbyBars:lat withLongitude:lng];
    
    [latStr release];
    [lngStr release];
}

- (void) fetchNearbyBars:(NSString *)latitude withLongitude:(NSString *)longitude {
    NSLog(@"Inside fetchNearbyBars");
    
    bars = [[NSMutableArray alloc] init];
    
    NSString* urlString = @"http://localhost:8888/barview/index.php/rest/nearbybars";
    
    NSLog(@"Trying URL %@ for bars near latitude %@ and longitude %@", urlString, latitude, longitude);
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    [urlString release];
    
    // Set up request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:latitude forHTTPHeaderField:@"Latitude"];
    [request addValue:longitude forHTTPHeaderField:@"Longitude"];
    
    // Clear out connection if one already exists
    if (nearbyBarConnection) {
        [nearbyBarConnection cancel];
        [nearbyBarConnection release];
    }
    
    // Initialize the XML structure
    [nearbyBarData release];
    nearbyBarData = [[NSMutableData alloc] init];
    
    // Create and initiate the (non-blocking) connection
    nearbyBarConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}



/*******************
 * URL CONNECTIONS
 ******************/


/*
 * When we get data back from the HTTP request we want to reset the data structure.
 */
- (void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse*) response {
    [nearbyBarData setLength:0];
}

/*
 * Append the data we receive to our data structure.
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
	[nearbyBarData appendData:d];
}

/*
 * Perform logging and error handling when an error occurs with the URL connection.
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
	NSLog(@"Connection error happened.");
    
    [nearbyBarConnection release];
    nearbyBarConnection = nil;
}

/*
 * The callback function that handles the results of requests to the Google geocoding API.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    NSString* xmlCheck = [[[NSString alloc] initWithData:nearbyBarData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"xml check = %@", xmlCheck);
    
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:nearbyBarData];
    [parser setDelegate:self];
    
    // Instruct the parser to start parsing - this is a blocking call.
    [parser parse];
    
    //The parser is done at this point, so release it and reload the table data.
    [parser release];
    
    for (int i=0; i<[bars count]; i++) {
        Bar* b = [bars objectAtIndex:i];
        
        CLLocationCoordinate2D loc;
        loc.latitude = [[b latitude] floatValue];
        loc.longitude = [[b longitude] floatValue];
        MapPoint *mp = [[MapPoint alloc] initWithCoordinate:loc title:[b name]];
        [mp setSubtitle:[b addr]];
        
        [mapView addAnnotation:mp];
        [mp release];
    }
    
    NSLog(@"There are currently %d map annotations.", [[mapView annotations] count]);
}




/***********************
 * XML PARSING METHODS
 **********************/

/**
 * Alerts us that the XML parser has found a new element that it will
 * begin parsing.  In this method we will change the state so we know
 * which string to append data to until the end tag is reached.
 */
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"Processing start tag %@", elementName);
    
    parseState = [[NSMutableString alloc] initWithString:elementName];
    if ([elementName isEqualToString:@"name"]) {
        barName = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"address"]) {
        addr = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"bar_id"]) {
        barId = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"lat"]) {
        latStr = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"lng"]) {
        lngStr = [[NSMutableString alloc] init];
    }
}

/**
 * Keep adding characters within a given set of tags as long as there are more characters.
 */
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([parseState isEqualToString:@"name"]) {
        [barName appendString:string];
    }
    else if([parseState isEqualToString:@"address"]) {
        [addr appendString:string];
    }
    else if([parseState isEqualToString:@"bar_id"]) {
        [barId appendString:string];
    }
    else if([parseState isEqualToString:@"lat"]) {
        [latStr appendString:string];
    }
    else if([parseState isEqualToString:@"lng"]) {
        [lngStr appendString:string];
    }
}

/**
 * We've found an end tag.  However, we only want to add an entry to the table when the whole
 * XML entity for a single bar has been parsed.  We know this occurs when we process a 
 * </com.barview.rest.Favorite> tag.
 */
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"Processing end tag %@", elementName);
    if ([elementName isEqualToString:@"bar"]) {
        Bar* b = [[Bar alloc] init];
        [b setBarId:[[NSString alloc] initWithString:barId]];
        [b setName:[[NSString alloc] initWithString:barName]];
        [b setAddr:[[NSString alloc] initWithString:addr]];
        [b setCity:@"Medfield"];
        [b setState:@"MA"];
        [b setZip:@"02052"];
        [b setLatitude:[[NSString alloc] initWithString:latStr]];
        [b setLongitude:[[NSString alloc] initWithString:lngStr]];
        
        [bars addObject:b];
        [b release];
        
        [barName release];
        barName = nil;
        
        [addr release];
        addr = nil;
        
        [barId release];
        barId = nil;
        
        [latStr release];
        latStr = nil;
        
        [lngStr release];
        lngStr = nil;
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"ERROR PARSING XML: %@", [parseError localizedDescription]);
}


@end
