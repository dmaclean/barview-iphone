//
//  CurrentTimeViewController.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrentTimeViewController : UIViewController {
	IBOutlet UILabel *timeLabel;
}

- (IBAction) showCurrentTime:(id) sender;

@end
