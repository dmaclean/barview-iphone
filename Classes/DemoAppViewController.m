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


#import "DemoAppViewController.h"
#import "FBConnect.h"

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
static NSString* kAppId = @"177771455596726";

@implementation DemoAppViewController

@synthesize label = _label, facebook;

//////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

/**
 * initialization
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (!kAppId) {
    NSLog(@"missing app id!");
    exit(1);
    return nil;
  }

    facebook = [[Facebook alloc] initWithAppId:kAppId];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Set the Barview logged-in flag to false by default.
    bvLoggedIn = NO;

  return self;
}

/**
 * Set initial view
 */
- (void)viewDidLoad {
    
    // User hasn't logged in.  Show login button.
    if (![facebook isSessionValid]) {
        _fbButton.isLoggedIn = NO;
        [_fbButton updateImage];
        
        barviewLogin.hidden = NO;
    }
    // User is logged in.  Show logout button.
    else {
        _fbButton.isLoggedIn = YES;    
        [_fbButton updateImage];
        
        barviewLogin.hidden = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
  [_fbButton release];
  [facebook release];
  [_permissions release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Show the authorization dialog.
 */
- (void)login {
    //[facebook authorize:_permissions delegate:self];
    if (![facebook isSessionValid]) {
        [facebook authorize:nil delegate:self];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
  [facebook logout:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// IBAction

/**
 * Called on a login/logout button click.
 */
- (IBAction)fbButtonClick:(id)sender {
  if (_fbButton.isLoggedIn) {
    [self logout];
  } else {
    [self login];
  }
}

- (IBAction) bvButtonClick:(id)sender {
    if(bvLoggedIn) {
        NSLog(@"%@", @"User is logged in");
        _fbButton.hidden = NO;
    }
    else {
        NSLog(@"%@", @"User is not logged in");
        _fbButton.hidden = YES;
    }
}

- (void) publishStream:(id)sender {
    
}

- (void) getPublicInfo:(id)sender {
    
}

- (void) uploadPhoto:(id)sender {
    
}

- (void) getUserInfo:(id)sender {
    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    _fbButton.isLoggedIn         = YES;
    [_fbButton updateImage];
    
    barviewLogin.hidden = YES;
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
  NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
  //[self.label setText:@"Please log in"];
  _getUserInfoButton.hidden    = YES;
  _getPublicInfoButton.hidden   = YES;
  _publishButton.hidden        = YES;
  _uploadPhotoButton.hidden = YES;
  _fbButton.isLoggedIn         = NO;
  [_fbButton updateImage];
    
    barviewLogin.hidden = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults removeObjectForKey:@"fbId"];
    [defaults removeObjectForKey:@"fbName"];
    [defaults synchronize];
    
    NSLog(@"Logged out of Facebook");
}




/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
  if ([result isKindOfClass:[NSArray class]]) {
    result = [result objectAtIndex:0];
  }
  if ([result objectForKey:@"owner"]) {
    [self.label setText:@"Photo upload Success"];
  } else {
    [self.label setText:[result objectForKey:@"name"]];
      
      // Save off the user's name and facebook id.  The name can be used for personalization
      // and the id will be sent with all requests to identify the user on the server side.
      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
      [defaults setObject:[result objectForKey:@"id"] forKey:@"fbId"];
      [defaults setObject:[result objectForKey:@"name"] forKey:@"fbName"];
  }
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
  [self.label setText:[error localizedDescription]];
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
  [self.label setText:@"publish successfully"];
}

@end
