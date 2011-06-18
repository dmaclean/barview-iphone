//
//  BarMapLookup.h
//  Hypnotime
//
//  Created by Dan MacLean on 6/1/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapPoint.h"

#define GOOGLE_OUPUT_FORMAT_CSV		@"csv"
#define GOOGLE_OUPUT_FORMAT_XML		@"xml"

@interface BarMapLookup : UIViewController <UIApplicationDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
	CLLocationManager* locationManager;
	
	NSURLConnection* connection;
	NSMutableData* data;
    NSMutableArray* annotations;
	
	IBOutlet MKMapView* mapView;
	IBOutlet UITextField* locationField;
}

@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) NSMutableData* data;

- (void) getMapCoordinates:(NSString*) address;

@end
