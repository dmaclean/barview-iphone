//
//  MapImageDetailController.h
//  Barview
//
//  Created by Dan MacLean on 7/13/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Base64.h"


@interface MapImageDetailController : UIViewController <NSXMLParserDelegate> {
    NSString* barId;
    NSString* barName;
    
    NSURLConnection*    connectionInProgress;
    NSMutableData*      xmlData;
    NSMutableString*    imageString;
    
    NSMutableString* parseState;
    
    IBOutlet UIImageView* barImage;
    
    IBOutlet UIButton* refresh;
}

@property (nonatomic, assign) NSString* barId;
@property (nonatomic, assign) NSString* barName;

-(IBAction) refreshImage:(id)sender;
-(void) fetchBarImage;

@end
