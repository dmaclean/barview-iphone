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
#import "NearbyBarFetcher.h"

#define GOOGLE_OUPUT_FORMAT_CSV		@"csv"
#define GOOGLE_OUPUT_FORMAT_XML		@"xml"

@interface BarMapLookup : UIViewController <UIApplicationDelegate, MKMapViewDelegate, CLLocationManagerDelegate, NSXMLParserDelegate> {
	CLLocationManager* locationManager;
	
	NSURLConnection* lookupConnection;
    
	NSMutableData* data;
    //NSMutableArray* annotations;
    
    // Data for the Nearby Bars call-out.
    NSURLConnection* nearbyBarConnection;
    
    NSMutableData* nearbyBarData;
    
    NSMutableString*    parseState;      // Describes which XML element is being processed.
    NSMutableString*    barId;
    NSMutableString*    barName;
    NSMutableString*    addr;
    NSMutableString*    city;
    NSMutableString*    state;
    NSMutableString*    zip;
    NSMutableString*    latStr;
    NSMutableString*    lngStr;
    
    NSMutableArray*     bars;
	
	IBOutlet MKMapView* mapView;
	IBOutlet UITextField* locationField;
}

@property (nonatomic, retain) NSURLConnection* lookupConnection;
@property (nonatomic, retain) NSURLConnection* nearbyBarConnection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableData* nearbyBarData;

- (void) getMapCoordinates:(NSString*) address;
//- (NSMutableArray*) getSurroundingBars:(NearbyBarFetcher*) fetcher withLatitude:(NSString*) latitude withLongitude:(NSString*) longitude;
- (void) fetchNearbyBars:(NSString *)latitude withLongitude:(NSString *)longitude;

@end
