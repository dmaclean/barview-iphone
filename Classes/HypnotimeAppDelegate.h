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

#import "BaseLoginManager.h"
#import "DemoAppViewController.h"
#import "BVActionsController.h"
#import "FBConnect.h"
#import "LoginManagerFactory.h"

@interface HypnotimeAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate, FBSessionDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
    BVActionsController* bvActionsController;
	CLLocationManager *locationManager;
    
    DemoAppViewController* controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

