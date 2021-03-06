//
//  MapImageDetailController.m
//  Barview
//
//  Created by Dan MacLean on 7/13/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "MapImageDetailController.h"


@implementation MapImageDetailController

@synthesize barId, barName;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"In INIT");
    }
    return self;
}*/

- (void)dealloc
{
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
    NSLog(@"in viewDidLoad");
    
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
	
	// Change the navigation item to display the name of possession.
    
    NSMutableString* title = [[NSMutableString alloc] initWithFormat:@"%@", [self barName]];
	[[self navigationItem] setTitle:title];
    [title release];
    
    barImage.image = nil;
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.navigationItem.rightBarButtonItem = nil;
    
    // Only add the "+Faves" button if the user is logged in (otherwise we won't know the user id to
    // associate the favorited bar to) and the bar isn't already a favorite.
    if ([lm userLoggedIn] && ![lm hasBarAsFavorite:[self barId]]) {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"+Faves" style:UIBarButtonItemStylePlain
                                                                         target:self action:@selector(addToFavorites:)];      
        self.navigationItem.rightBarButtonItem = anotherButton;
        [anotherButton release];
    }
    
    [self fetchBarImage];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
     
    [barImage resignFirstResponder];
}

- (IBAction) refreshImage:(id)sender {
    NSLog(@"Hit the refresh button");
    [self fetchBarImage];
}

- (void) addToFavorites:(id)sender {
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    
    // Configure the correct URL for our image (we need to convert the bar id to an integer for some reason because
    // treating it like a string causes a newline to show up and fucks up the URL).
    NSMutableString* urlString = [[NSMutableString alloc] 
                                  initWithFormat:@"%@/%d", [BarviewURLUtility getFavoriteURLForRunMode], [[self barId] integerValue]];
    
    NSLog(@"Trying URL %@ for bar id %@abc", urlString, [self barId]);
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    [urlString release];
    
    // Set up request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Add the User_id header to the request.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = nil;
    if ([lm getType] == [LoginManagerFactory getBarviewType]) {
        userId = [defaults objectForKey:@"email"];
    }
    else if ([lm getType] == [LoginManagerFactory getFacebookType]) {
        NSString* fbId = [defaults objectForKey:@"fbId"];
        userId = [NSString stringWithFormat:@"fb%@", fbId];
    }
    [request addValue:userId forHTTPHeaderField:@"User_id"];
    
    
    // Clear out connection if one already exists
    if (connectionForFavorites) {
        [connectionForFavorites cancel];
        [connectionForFavorites release];
    }
    
    // Initialize the XML structure
    [xmlForFaves release];
    xmlForFaves = [[NSMutableData alloc] init];
    
    // Create and initiate the (non-blocking) connection
    connectionForFavorites = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void) fetchBarImage {
    // Configure the correct URL for our image (we need to convert the bar id to an integer for some reason because
    // treating it like a string causes a newline to show up and fucks up the URL).
    NSMutableString* urlString = [[NSMutableString alloc] 
                                  initWithFormat:@"%@/%d", [BarviewURLUtility getBarImageURLForRunMode], [[self barId] integerValue]];
    
    NSLog(@"Trying URL %@ for bar id %@abc", urlString, [self barId]);
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    [urlString release];
    
    // Set up request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    if ([lm userLoggedIn]) {
        [request addValue:[lm getUserId] forHTTPHeaderField:@"User_id"];
    }
    
    // Clear out connection if one already exists
    if (connectionInProgress) {
        [connectionInProgress cancel];
        [connectionInProgress release];
    }
    
    // Initialize the XML structure
    [xmlData release];
    xmlData = [[NSMutableData alloc] init];
    
    // Create and initiate the (non-blocking) connection
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

/********************************
 * CONNECTION HANDLER FUNCTIONS
 *******************************/

/**
 * Append data to the structure that holds favorites as the data comes in.
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == connectionForFavorites)
        [xmlForFaves appendData:data];
    else if(connection == connectionInProgress)
        [xmlData appendData:data];
}

/**
 * Print out the XML result to console to show that we've received it all.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == connectionInProgress) {
        NSString* xmlCheck = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"xml check = %@", xmlCheck);
        
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData:xmlData];
        [parser setDelegate:self];
        
        // Instruct the parser to start parsing - this is a blocking call.
        [parser parse];
        
        //The parser is done at this point, so release it and reload the table data.
        [parser release];
    }
    else {
        NSLog(@"Added to faves");
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/**
 * In the event of an error with fetching the favorites we want to release and null out the
 * connection and xml data structure.
 *
 * We are also going to show the user a message letting them know the fetch failed.
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    connection = nil;
    
    if (connection == connectionInProgress) {
        [xmlData release];
        xmlData = nil;
    }
    else {
        [xmlForFaves release];
        xmlForFaves = nil;

    }
    
    NSString* errorString = [NSString stringWithFormat:@"Fetch failed %@", [error localizedDescription]];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet autorelease];
}


/**********************************
 * XML PARSER CALLBACK FUNCTIONS
 *********************************/
/**
 * Alerts us that the XML parser has found a new element that it will
 * begin parsing.  In this method we will change the state so we know
 * which string to append data to until the end tag is reached.
 */
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    parseState = [[NSMutableString alloc] initWithString:elementName];
    if ([elementName isEqualToString:@"image"]) {
        imageString = [[NSMutableString alloc] init];
    }
}

/**
 * Keep adding characters within a given set of tags as long as there are more characters.
 */
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([parseState isEqualToString:@"image"]) {
        [imageString appendString:string];
    }
}

/**
 * We've found an end tag.  However, we only want to add an entry to the table when the whole
 * XML entity for a single bar has been parsed.  We know this occurs when we process a 
 * </com.barview.rest.Favorite> tag.
 */
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"Processing end tag %@", elementName);
    if ([elementName isEqualToString:@"barimage"]) {
        NSData* b64DecData = [Base64 decodeBase64WithString:imageString];
        UIImage* img = [[UIImage alloc] initWithData:b64DecData];
        //barImage.image = img;
        //[barImage initWithImage:img];
        
        [barImage setImage:img];
        
        [img release];
        
        [imageString release];
        imageString = nil;
    }
    
    
    
    //[barImage setImage:nil];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"ERROR PARSING XML: %@", [parseError localizedDescription]);
}

@end
