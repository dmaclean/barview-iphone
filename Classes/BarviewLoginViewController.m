//
//  BarviewLoginViewController.m
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarviewLoginViewController.h"


@implementation BarviewLoginViewController

@synthesize loginButton, username, password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[self navigationItem] setTitle:@"Barview Login"];
    }
    return self;
}

- (void)dealloc
{
    [firstname release];
    [lastname release];
    [email release];
    [dob release];
    [city release];
    [state release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.username = nil;
    self.password = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [username setText:@""];
    [password setText:@""];
    
    [username becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction) authenticate:(id)sender {
    
    // Construct URL
    NSURL* url = [NSURL URLWithString:[BarviewURLUtility getBarviewLoginURLForRunMode]];
    
    // Construct request object
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [request addValue:[username text] forHTTPHeaderField:@"BV_USERNAME"];
    [request addValue:[password text] forHTTPHeaderField:@"BV_PASSWORD"];
    
    
    // Clear out existing connection if one exists
    if(connectionInProgress) {
        [connectionInProgress cancel];
        [connectionInProgress release];
    }
    
    // Instantiate the data structure
    [xmlData release];
    xmlData = [[NSMutableData alloc] init];
    
    // Create and initiate the (non-blocking) connection
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void) clearLoginData {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"firstname"];
    [defaults removeObjectForKey:@"lastname"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"dob"];
    [defaults removeObjectForKey:@"city"];
    [defaults removeObjectForKey:@"state"];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"usertype"];
}

/**
 * Append data to the structure that holds favorites as the data comes in.
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [xmlData appendData:data];
}

/**
 * Print out the XML result to console to show that we've received it all.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* xmlCheck = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"xml check = %@", xmlCheck);
    
    // Clear out any previous data so we can get it fresh from the server.
    [self clearLoginData];
    
    
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    
    // Instruct the parser to start parsing - this is a blocking call.
    [parser parse];
    
    //The parser is done at this point, so release it and send the user back to the main login screen.
    [parser release];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"First name: %@", [defaults valueForKey:@"firstname"]);
    NSLog(@"Last name: %@", [defaults valueForKey:@"lastname"]);
    NSLog(@"Email: %@", [defaults valueForKey:@"email"]);
    NSLog(@"DOB: %@", [defaults valueForKey:@"dob"]);
    NSLog(@"City: %@", [defaults valueForKey:@"city"]);
    NSLog(@"State: %@", [defaults valueForKey:@"state"]);
    NSLog(@"Token: %@", [defaults valueForKey:@"token"]);
    
    // We don't have a token, so we know that login failed.  Give the user a message and clear the password field.
    if (![defaults valueForKey:@"token"]) {
        [password setText:@""];
        
        NSString* errorString = [NSString stringWithFormat:@"Invalid credentials."];
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
        [actionSheet autorelease];
        [actionSheet showInView:[self view]];
    }
    // We got a token, so login succeeded.  Tell the LoginManager factory that we have a barview user
    // and send the user back to the main login screen.
    else {
        [LoginManagerFactory setLoginManagerType:[LoginManagerFactory getBarviewType]];
        [defaults setValue:[LoginManagerFactory getBarviewType] forKey:@"usertype"];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

/**
 * In the event of an error with fetching the favorites we want to release and null out the
 * connection and xml data structure.
 *
 * We are also going to show the user a message letting them know the fetch failed.
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connectionInProgress release];
    connectionInProgress = nil;
    
    [xmlData release];
    xmlData = nil;
    
    NSString* errorString = [NSString stringWithFormat:@"Unable to log in to Barview.  Please try again later. %@", [error localizedDescription]];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet autorelease];
}



/***********************
 * XML PARSING METHODS
 **********************/

/**
 * Alerts us that the XML parser has found a new element that it will
 * begin parsing.  In this method we will change the state so we know
 * which string to append data to until the end tag is reached.
 */
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    parseState = [[NSMutableString alloc] initWithString:elementName];
    if ([elementName isEqualToString:@"firstname"]) {
        firstname = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"lastname"]) {
        lastname = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"email"]) {
        email = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"dob"]) {
        dob = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"city"]) {
        city = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"state"]) {
        state = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"token"]) {
        token = [[NSMutableString alloc] init];
    }
}

/**
 * Keep adding characters within a given set of tags as long as there are more characters.
 */
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([parseState isEqualToString:@"firstname"]) {
        [firstname appendString:string];
    }
    else if ([parseState isEqualToString:@"lastname"]) {
        [lastname appendString:string];
    }
    else if ([parseState isEqualToString:@"email"]) {
        [email appendString:string];
    }
    else if ([parseState isEqualToString:@"dob"]) {
        [dob appendString:string];
    }
    else if ([parseState isEqualToString:@"city"]) {
        [city appendString:string];
    }
    else if ([parseState isEqualToString:@"state"]) {
        [state appendString:string];
    }
    else if ([parseState isEqualToString:@"token"]) {
        [token appendString:string];
    }
}

/**
 * We've found an end tag.  However, we only want to add an entry to the table when the whole
 * XML entity for a single bar has been parsed.  We know this occurs when we process a 
 * </com.barview.rest.Favorite> tag.
 */
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"Processing end tag %@", elementName);
    if ([elementName isEqualToString:@"firstname"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:firstname forKey:@"firstname"];
    }
    else if ([elementName isEqualToString:@"lastname"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:lastname forKey:@"lastname"];
    }
    else if ([elementName isEqualToString:@"email"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:email forKey:@"email"];
    }
    else if ([elementName isEqualToString:@"dob"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:dob forKey:@"dob"];
    }
    else if ([elementName isEqualToString:@"city"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:city forKey:@"city"];
    }
    else if ([elementName isEqualToString:@"state"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:state forKey:@"state"];
    }
    else if ([elementName isEqualToString:@"token"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:token forKey:@"token"];
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"ERROR PARSING XML: %@", [parseError localizedDescription]);
}


@end
