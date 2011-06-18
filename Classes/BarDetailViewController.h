//
//  BarDetailViewController.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/31/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"


@interface BarDetailViewController : UIViewController {
	Bar* bar;
	
	IBOutlet UILabel* nameField;
	IBOutlet UILabel* addrField;
	IBOutlet UILabel* cityField;
	IBOutlet UITextField* stateField;
	IBOutlet UITextField* zipField;
}

@property (nonatomic, assign) Bar* bar;

@end
