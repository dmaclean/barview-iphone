/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import <UIKit/UIKit.h>
#import "BaseLoginManager.h"
#import "BarviewURLUtility.h"
#import "BarviewLoginViewController.h"
#import "FBConnect.h"
#import "FBLoginButton.h"
#import "LoginManagerFactory.h"


@interface DemoAppViewController : UIViewController <FBSessionDelegate, FBRequestDelegate> {
  IBOutlet UILabel* _label;
  IBOutlet FBLoginButton* _fbButton;
    IBOutlet UIButton* barviewLogin;
  IBOutlet UIButton* _getUserInfoButton;
  IBOutlet UIButton* _getPublicInfoButton;
  IBOutlet UIButton* _publishButton;
  IBOutlet UIButton* _uploadPhotoButton;
    
    Boolean* bvLoggedIn;
    
    BarviewLoginViewController* barviewLoginViewController;
    
    NSURLConnection* connectionInProgress;
    
  Facebook* facebook;
  NSArray* _permissions;
}

@property(nonatomic, retain) UILabel* label;

@property(nonatomic, retain) Facebook *facebook;

@property(nonatomic, retain) BarviewLoginViewController* barviewLoginViewController;

-(IBAction)fbButtonClick:(id)sender;

-(IBAction) bvButtonClick:(id)sender;

-(IBAction)getUserInfo:(id)sender;

-(IBAction)getPublicInfo:(id)sender;

-(IBAction)publishStream:(id)sender;

-(IBAction)uploadPhoto:(id)sender;

-(void) bvLogout;

@end
