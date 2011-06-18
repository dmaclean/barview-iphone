//
//  FavoritesController.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/30/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarDetailViewController.h"

@interface FavoritesController : UITableViewController {
	BarDetailViewController* detailViewController;
	NSMutableArray* favorites;
}

@end
