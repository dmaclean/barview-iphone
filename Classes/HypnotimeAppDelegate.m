//
//  HypnotimeAppDelegate.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "HypnotimeAppDelegate.h"
#import "BarMapLookup.h"
#import "CurrentLocation.h"
#import "FacebookSingleton.h"
#import "FavoritesController.h"
#import "MapPoint.h"

@implementation HypnotimeAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // Create a dictionary for favorite bars.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
    if (!faves) {
        faves = [[NSMutableDictionary alloc] init];
        [defaults setValue:faves forKey:@"faves"];
        [defaults synchronize];
    }
    

	// Create the tab bar controller
	tabBarController = [[UITabBarController alloc] init];
	
	// Set up the Navigation controller for the favorites
	FavoritesController* faveController = [[FavoritesController alloc] init];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:faveController];
	[[navController tabBarItem] setTitle:@"Favorite Bars"];
    
    // Set up the Navigation controller for Map Lookup
    BarMapLookup* lookupController = [[BarMapLookup alloc] init];
    UINavigationController* lookupNavController = [[UINavigationController alloc] initWithRootViewController:lookupController];
    [[lookupNavController tabBarItem] setTitle:@"Bar Lookup"];
    
    // Set up the Navigation controller for Current Location
    CurrentLocation* currLocController = [[CurrentLocation alloc] init];
    UINavigationController* currLocNavController = [[UINavigationController alloc] initWithRootViewController:currLocController];
    [[currLocNavController tabBarItem] setTitle:@"Current Location"];
    
    // Set up the view controller for facebook login
    controller = [[DemoAppViewController alloc] init];
    [[controller tabBarItem] setTitle:@"Facebook login"];
	
	// Create three view controllers
	UIViewController *vc1 = lookupNavController;
	UIViewController *vc2 = navController;
	UIViewController *vc3 = currLocNavController;
    UIViewController *vc4 = controller;
	
	// Make an array containing the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, nil];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
    [vc4 release];
    
    [faveController release];
    [currLocController release];
    [lookupController release];
	
	// Attach them to the tab bar controller
	[tabBarController setViewControllers:viewControllers];
	
	// Put the tabBarController's view on the window
	[window addSubview:[tabBarController view]];
    
    [self.window makeKeyAndVisible];
    
    NSLog(@"Is logged in? %@", [FacebookSingleton userLoggedIn] ? @"YES" : @"NO");
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[controller facebook] handleOpenURL:url];
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
