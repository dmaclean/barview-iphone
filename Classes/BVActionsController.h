//
//  BVActionsController.h
//  Barview
//
//  Created by Dan MacLean on 11/13/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BarMapLookup.h"
#import "BaseLoginManager.h"
#import "CurrentLocation.h"
#import "DemoAppViewController.h"
#import "FavoritesController.h"
#import "LoginManagerFactory.h"


@interface BVActionsController : UITableViewController {
    NSMutableArray* bvActions;
    
    NSString* ACTION_FINDBARS;
    NSString* ACTION_CURRLOC;
    NSString* ACTION_FAVORITES;
    NSString* ACTION_LOGOUT;
    NSString* ACTION_LOGIN;
    
    BarMapLookup* barMapLookup;
    CurrentLocation* currentLocation;
    DemoAppViewController* loginController;
    FavoritesController* favoritesController;
}

@property (retain) DemoAppViewController* loginController;

@end
