//
//  BarDetailViewController.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/31/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarDetailViewController.h"


@implementation BarDetailViewController
@synthesize bar;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[nameField setText:[bar name]];
	[addrField setText:[bar addr]];
	[cityField setText:[bar city]];
	[stateField setText:[bar state]];
	[zipField setText:[bar zip]];
	
	// Change the navigation item to display the name of possession.
	[[self navigationItem] setTitle:[bar name]];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// Clear first responder
	[nameField resignFirstResponder];
	[addrField resignFirstResponder];
	[cityField resignFirstResponder];
	[stateField resignFirstResponder];
	[zipField resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"BarDetailViewController - viewDidAppear");
    
    barImage.image = nil;
    
    [self fetchBarImage];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[nameField release];
	nameField = nil;
	
	[nameField release];
	nameField = nil;
	
	[addrField release];
	addrField = nil;
	
	[cityField release];
	cityField = nil;
	
	[stateField release];
	stateField = nil;
	
	[zipField release];
	zipField = nil;
    
    [barImage release];
    barImage = nil;
}


- (void)dealloc {
	[nameField release];
	[addrField release];
	[cityField release];
	[stateField release];
	[zipField release];
    [barImage release];
	
    [super dealloc];
}

- (IBAction) refreshImage:(id)sender {
    NSLog(@"Fetching latest image");
    
    [self fetchBarImage];
}

- (void) fetchBarImage {
    // Configure the correct URL for our image (we need to convert the bar id to an integer for some reason because
    // treating it like a string causes a newline to show up and fucks up the URL).
    NSMutableString* urlString = [[NSMutableString alloc] 
                                  initWithFormat:@"http://localhost:8888/barview/index.php/rest/barimage/%d", [[bar barId] integerValue]];

    NSLog(@"Trying URL %@ for bar id %@", urlString, [bar barId]);
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    [urlString release];
    
    // Set up request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    if ([lm userLoggedIn]) {
        [request addValue:[lm getUserId] forHTTPHeaderField:@"User_id"];
    }
    
    [url release];
    
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
    [xmlData appendData:data];
}

/**
 * Print out the XML result to console to show that we've received it all.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* xmlCheck = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"xml check = %@", xmlCheck);
    
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    
    // Instruct the parser to start parsing - this is a blocking call.
    [parser parse];
    
    //The parser is done at this point, so release it and reload the table data.
    [parser release];
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
    
    [xmlData release];
    xmlData = nil;
    
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
        
        [barImage setImage:img];
        
        [img release];
        
        [imageString release];
        imageString = nil;
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"ERROR PARSING XML: %@", [parseError localizedDescription]);
}


@end
