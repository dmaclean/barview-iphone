//
//  CurrentLocation.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "Bar.h"
#import "MapPointView.h"

@interface CurrentLocation : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, NSXMLParserDelegate> {
	CLLocationManager *locationManager;
	
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
    
	IBOutlet MKMapView *mapView;
}

@property (nonatomic, retain) NSURLConnection* nearbyBarConnection;
@property (nonatomic, retain) NSMutableData* nearbyBarData;

- (void) fetchNearbyBars:(NSString *)latitude withLongitude:(NSString *)longitude;

@end
