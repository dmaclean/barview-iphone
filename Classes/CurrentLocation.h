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

@interface CurrentLocation : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	
	IBOutlet MKMapView *mapView;
}

@end
