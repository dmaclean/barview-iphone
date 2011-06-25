//
//  BarDetailViewController.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/31/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base64.h"
#import "Bar.h"


@interface BarDetailViewController : UIViewController <NSXMLParserDelegate> {
	Bar* bar;
    
    NSURLConnection*    connectionInProgress;
    NSMutableData*      xmlData;
    NSMutableString*    imageString;
    
    NSMutableString* parseState;
	
	IBOutlet UILabel* nameField;
	IBOutlet UILabel* addrField;
	IBOutlet UILabel* cityField;
	IBOutlet UITextField* stateField;
	IBOutlet UITextField* zipField;
    
    IBOutlet UIImageView* barImage;
}

-(void) fetchBarImage;

@property (nonatomic, assign) Bar* bar;


@end
