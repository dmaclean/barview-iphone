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

@synthesize label = _label, facebook, barviewLoginViewController;

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
    
    barviewLoginViewController = [[BarviewLoginViewController alloc] initWithNibName:@"BarviewLoginViewController" bundle:nibBundleOrNil];

  return self;
}

/**
 * Set initial view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    
    // User hasn't logged in.  Show all login buttons.
    if (![lm userLoggedIn]) {
        // Facebook
        _fbButton.isLoggedIn = NO;
        [_fbButton updateImage];
        
        // Barview
        barviewLogin.hidden = NO;
    }
    // User is logged in.  Figure out which account they're logged in with, show its logout button, and hide the rest.
    else {
        if ([lm getType] == [LoginManagerFactory getBarviewType]) {
            barviewLogin.hidden = NO;
            [barviewLogin setTitle:@"Logout" forState:UIControlStateNormal];
            
            _fbButton.isLoggedIn = NO;    
            [_fbButton updateImage];
            _fbButton.hidden = YES;
        }
        else if ([lm getType] == [LoginManagerFactory getFacebookType]) {
            _fbButton.hidden = NO;
            _fbButton.isLoggedIn = YES;
            [_fbButton updateImage];
            
            barviewLogin.hidden = YES;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
  [_fbButton release];
  [facebook release];
  [_permissions release];
    
    if (connectionInProgress) {
        [connectionInProgress cancel];
        [connectionInProgress release];
    }
    
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Show the authorization dialog.
 */
- (void)login {
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    
    //[facebook authorize:_permissions delegate:self];
    if (![lm userLoggedIn]) {
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

/**
 * Actions that will be performed when the user clicks on the Barview login/logout button.
 */
- (IBAction) bvButtonClick:(id)sender {
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    
    // User is logged in.  Log them out.
    if([lm userLoggedIn]) {
        [self bvLogout];
        
        [barviewLogin setTitle:@"Barview Login" forState:UIControlStateNormal];
        
        _fbButton.hidden = NO;
    }
    // User is not logged in.  Attempt to log them in.
    else {
        [[self navigationController] pushViewController:barviewLoginViewController animated:YES];
    }
}

/**
 * Invokes an HTTP call to the server to log the user out.  A successful call will
 * invalidate the user's token on the server side (making any further requests with
 * it to fail), and clear out the NSUserDefault values here on the app.
 */
- (void) bvLogout {
    // Construct URL
    NSURL* url = [NSURL URLWithString:@"http://localhost:8888/barview/index.php/mobilelogin"];
    
    // Construct request object
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [request addValue:[defaults valueForKey:@"token"] forHTTPHeaderField:@"BV_TOKEN"];
    
    
    // Clear out existing connection if one exists
    if(connectionInProgress) {
        [connectionInProgress cancel];
        [connectionInProgress release];
    }
    
    // Create and initiate the (non-blocking) connection
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

/**
 * FACEBOOK FBREQUEST CALLBACKS
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Received FBRequest response");
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
};

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
    
    // Save off the user's name and facebook id.  The name can be used for personalization
    // and the id will be sent with all requests to identify the user on the server side.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[result objectForKey:@"id"] forKey:@"fbId"];
    [defaults setObject:[result objectForKey:@"name"] forKey:@"fbName"];
};



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
    
    // get information about the currently logged in user
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    
    _fbButton.isLoggedIn         = YES;
    [_fbButton updateImage];
    
    barviewLogin.hidden = YES;
    
    // Let the LoginManager factory know we've logged in with facebook.
    [LoginManagerFactory setLoginManagerType:[LoginManagerFactory getFacebookType]];
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
    
    // Let the LoginManager factory know we've logged out of facebook.
    [LoginManagerFactory setLoginManagerType:nil];
    
    NSLog(@"Logged out of Facebook");
}


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
  [self.label setText:@"publish successfully"];
}



/******************************
 * HTTP connection callbacks.
 *****************************/
// Print out the XML result to console to show that we've received it all.
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    // Clear out NSUserDefaults values
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"firstname"];
    [defaults removeObjectForKey:@"lastname"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"dob"];
    [defaults removeObjectForKey:@"city"];
    [defaults removeObjectForKey:@"state"];
    [defaults removeObjectForKey:@"token"];
    
    // Tell LoginManager factory that we no longer have a barview user.
    [LoginManagerFactory setLoginManagerType:nil];
}

/**
 * Show the user a message to let them know the logout failed.
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connectionInProgress release];
    connectionInProgress = nil;
    
    NSString* errorString = [NSString stringWithFormat:@"Unable to log out of Barview.  Please try again later. %@", [error localizedDescription]];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet autorelease];
}

@end
