//
//  HypnotimeAppDelegate.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "DemoAppViewController.h"

@interface HypnotimeAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	CLLocationManager *locationManager;
    
    DemoAppViewController* controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

