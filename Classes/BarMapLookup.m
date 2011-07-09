//
//  BarMapLookup.m
//  Hypnotime
//
//  Created by Dan MacLean on 6/1/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarMapLookup.h"


@implementation BarMapLookup

@synthesize data, nearbyBarData, nearbyBarConnection, lookupConnection;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		[[self tabBarItem] setTitle:@"Search Bars"];
        
        //annotations = [[NSMutableArray alloc] init];
		
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
	
	[self.lookupConnection cancel];
    [self.nearbyBarConnection cancel];
	
	self.lookupConnection = nil;
    self.nearbyBarConnection = nil;
	self.data = nil;
    self.nearbyBarData = nil;
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
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 500, 500);
	
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
    //[annotations addObject:mp];
	//[mapView addAnnotations:annotations];
    [mapView addAnnotation:mp];
	[mp release];
	
	[locationManager stopUpdatingLocation];
    
    NSString* newLatStr = [[NSString alloc] initWithFormat:@"%f", [newLocation coordinate].latitude];
    NSString* newLngStr = [[NSString alloc] initWithFormat:@"%f", [newLocation coordinate].longitude];
    [self fetchNearbyBars:newLatStr withLongitude:newLngStr];
    NSLog(@"Fetching nearby bars");
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
    if(lookupConnection) {
        [lookupConnection cancel];
        [lookupConnection release];
    }
    
    lookupConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/*
 * When we get data back from the HTTP request we want to reset the data structure.
 */
- (void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse*) response {
	if (connection == lookupConnection) {
        [data setLength:0];
    } else {
        [nearbyBarData setLength:0];
    }
}

/*
 * Append the data we receive to our data structure.
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
	if (connection == lookupConnection) {
        [data appendData:d];
    } else {
        [nearbyBarData appendData:d];
    }
}

/*
 * Perform logging and error handling when an error occurs with the URL connection.
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
	NSLog(@"Connection error happened.");
    
    if (connection == lookupConnection) {
        [lookupConnection release];
        lookupConnection = nil;
    }
    else {
        [nearbyBarConnection release];
        nearbyBarConnection = nil;
    }
}

/*
 * The callback function that handles the results of requests to the Google geocoding API.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    if (connection == lookupConnection) {
            
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
                
                [mapView removeAnnotations:[mapView annotations]];
                //[annotations removeAllObjects];
                
                // Create a MapPoint pin for the current location and add it to the map view and list of annotations.
                CLLocationCoordinate2D loc;
                loc.latitude = [lat floatValue];
                loc.longitude = [lon floatValue];
                MapPoint *mp = [[MapPoint alloc] initWithCoordinate:loc title:[locationField text]];
                [mapView addAnnotation:mp];
                //[annotations addObject:mp];
                
                // Get surrounding bars
                //NearbyBarFetcher* fetcher = [[NearbyBarFetcher alloc] init];
                /*NSMutableArray* barPoints = [self fetchNearbyBars:lat withLongitude:lon];
                for (int i=0; i<[barPoints count]; i++) {
                    MapPoint* point = [barPoints objectAtIndex:i];
                    [mapView addAnnotation:point];
                    [annotations addObject:point];
                }*/
                [self fetchNearbyBars:lat withLongitude:lon];
                
                
                // Not quite sure what this does.
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
    else if (connection == nearbyBarConnection) {
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
    }
    
    

}

- (MKAnnotationView*) mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"IN HERE!!!");
    NSLog(@"Number of annotations %d", [[mv annotations] count]);
    
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField*) tf {
	NSLog(@"textFieldShouldReturn");
	[self getMapCoordinates:[locationField text]];
	[tf resignFirstResponder];
	return YES;
}

/*-(NSMutableArray*) getSurroundingBars:(NearbyBarFetcher *)fetcher withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude {
    NSLog(@"Inside of getSurroundingBars using lat %@ and lng %@", latitude, longitude);
    
    NSMutableArray* currBars = [fetcher fetchNearbyBars:latitude withLongitude:longitude];
    
    NSMutableArray* barPoints = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[currBars count]; i++) {
        Bar* b = [currBars objectAtIndex:i];
        
        CLLocationCoordinate2D loc;
        loc.latitude = [latitude floatValue];
        loc.longitude = [longitude floatValue];
        MapPoint *mp = [[MapPoint alloc] initWithCoordinate:loc title:[b name]];
        [mp setSubtitle:[b addr]];
        
        [barPoints addObject:mp];
    }
    
    return barPoints;
}*/

-(void) fetchNearbyBars:(NSString *)latitude withLongitude:(NSString *)longitude {
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



- (void)dealloc {
	[lookupConnection cancel];
	[lookupConnection release];
    lookupConnection = nil;
    
    [nearbyBarConnection cancel];
    [nearbyBarConnection release];
    nearbyBarConnection = nil;
	
	[data release];
    [nearbyBarData release];
	
    [super dealloc];
}


@end
