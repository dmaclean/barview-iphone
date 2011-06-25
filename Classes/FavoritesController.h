//
//  FavoritesController.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/30/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarDetailViewController.h"

@interface FavoritesController : UITableViewController <NSXMLParserDelegate> {
	BarDetailViewController* detailViewController;
	NSMutableArray* favorites;
    NSMutableData* xmlData;
    NSURLConnection* connectionInProgress;
    
    NSMutableString*    parseState;      // Describes which XML element is being processed.
    NSMutableString*    barId;
    NSMutableString*    barName;
    NSMutableString*    address;
    NSMutableString*    city;
    NSMutableString*    state;
    NSMutableString*    zip;
    float               lat;
    float               lon;
}

- (void) loadFavorites;

@end
