//
//  HypnotimeAppDelegate.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "HypnotimeAppDelegate.h"
#import "HypnosisViewController.h"
#import "BarMapLookup.h"
#import "CurrentTimeViewController.h"
#import "CurrentLocation.h"
#import "FavoritesController.h"
#import "MapPoint.h"

@implementation HypnotimeAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	// Create the tab bar controller
	tabBarController = [[UITabBarController alloc] init];
	
	// Set up the Navigation controller for the favorites
	FavoritesController* faveController = [[FavoritesController alloc] init];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:faveController];
	[[navController tabBarItem] setTitle:@"Favorite Bars"];
	
	// Create three view controllers
	UIViewController *vc1 = [[BarMapLookup alloc] init];
	UIViewController *vc2 = navController;
	UIViewController *vc3 = [[CurrentLocation alloc] init];
	
	// Make an array containing the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, nil];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
	
	// Attach them to the tab bar controller
	[tabBarController setViewControllers:viewControllers];
	
	// Put the tabBarController's view on the window
	[window addSubview:[tabBarController view]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	[locationManager release];
    [super dealloc];
}


@end
