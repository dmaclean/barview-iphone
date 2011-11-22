//
//  DealsViewController.h
//  Barview
//
//  Created by Dan MacLean on 11/21/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BarviewURLUtility.h"
#import "BaseLoginManager.h"
#import "Deal.h"
#import "LoginManagerFactory.h"


@interface DealsViewController : UITableViewController <NSXMLParserDelegate> {
    NSMutableArray* deals;
    NSMutableData* xmlData;
    NSURLConnection* connectionInProgress;
    
    NSMutableString*    parseState;      // Describes which XML element is being processed.
    NSMutableString*    barName;
    NSMutableString*    detail;
    
    NSMutableArray* barsArray;
    NSMutableArray* dealsForBarsArray;
}

- (void) loadDeals;

@end
