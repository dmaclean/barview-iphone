//
//  BarviewLoginViewController.h
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginManagerFactory.h"


@interface BarviewLoginViewController : UIViewController <NSXMLParserDelegate> {
    NSMutableData* xmlData;
    NSURLConnection* connectionInProgress;
    
    IBOutlet UITextField* username;
    IBOutlet UITextField* password;
    
    UIButton* loginButton;
    
    NSMutableString*    parseState;      // Describes which XML element is being processed.
    NSMutableString*    firstname;
    NSMutableString*    lastname;
    NSMutableString*    email;
    NSMutableString*    dob;
    NSMutableString*    city;
    NSMutableString*    state;
    NSMutableString*    token;
}

@property (nonatomic, retain) IBOutlet UIButton* loginButton;
@property (nonatomic, retain) IBOutlet UITextField* username;
@property (nonatomic, retain) IBOutlet UITextField* password;

- (IBAction) authenticate:(id)sender;
- (void) clearLoginData;

@end
