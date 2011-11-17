    //
//  FavoritesController.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/30/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "FavoritesController.h"


@implementation FavoritesController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
        // Custom initialization.
		
		favorites = [[NSMutableArray alloc] init];
        [self loadFavorites];
		
		// Set the nav bar with the edit button
		[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
		
		// Set the title of the nav bar to Homepwner when
		// ItemsViewController is on top of the stack.
		[[self navigationItem] setTitle:@"Favorite Bars"];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFavorites];
}

- (NSInteger) tableView:(UITableView*) tv numberOfRowsInSection:(NSInteger) section {
	return [favorites count];
}

- (UITableViewCell*) tableView:(UITableView*) tv cellForRowAtIndexPath:(NSIndexPath*) indexPath {
	UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	Bar* b = [favorites objectAtIndex:[indexPath row]];
	[[cell textLabel] setText:[b name]];
	
	return cell;
}

/*
 * Set the information for the particular row selected so it shows up on the details screen.
 */
- (void) tableView:(UITableView*) tv didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
	// Lazily create an instance of BarDetailViewController
	if (!detailViewController)
		detailViewController = [[BarDetailViewController alloc] init];
	
	[detailViewController setBar:[favorites objectAtIndex:[indexPath row]]];
	
	[[self navigationController] pushViewController:detailViewController animated:YES];
}

/*
 * Commit delete changes made to the table view to the favorites array.
 */
- (void) tableView:(UITableView*) tv commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath:(NSIndexPath*) indexPath {
	
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    
	// Are we deleting?
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        Bar* b = [favorites objectAtIndex:[indexPath row]];
        NSString* bar_id = [b barId];
        //[b release];
        
		//////////////////////////////////////////////////////////////////////
        // Send a message to the REST server that we're deleting a favorite.
        //////////////////////////////////////////////////////////////////////
        // Construct URL
        NSMutableString* urlString = [[NSMutableString alloc] 
                                      initWithFormat:@"http://localhost:8888/barview/index.php/rest/favorite/%@", bar_id];
        NSURL* url = [NSURL URLWithString:urlString];
        
        // Construct request object
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        
        [request addValue:[lm getLogonToken] forHTTPHeaderField:@"user_id"];
        [request setHTTPMethod:@"DELETE"];
        
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
        
        
        
        
        
        // Remove the row from the data source
		[favorites removeObjectAtIndex:[indexPath row]];
        
        // Remove the favorite from the favorites dictionary
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
        [faves removeObjectForKey:bar_id];
		
		// Remove the row from the table view
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:/*YES*/UITableViewRowAnimationFade];
	}
}

/*
 * Commit any moves made to the table view to the favorites array.
 */
- (void) tableView:(UITableView*) tv moveRowAtIndexPath:(NSIndexPath*) fromPath toIndexPath:(NSIndexPath*) toPath {
	// Get a reference to the Bar object at the "from" row
	Bar* fromBar = [favorites objectAtIndex:[fromPath row]];
	
	// Retain fromBar so it isn't deallocated when removed from the array
	[fromBar retain];
	
	// Remove it from the array and re-insert at the new location.
	[favorites removeObjectAtIndex:[fromPath row]];
	[favorites insertObject:fromBar atIndex:[toPath row]];
	
	// We can release fromBar now since it is referenced by the favorites array.
	[fromBar release];
}

- (void)dealloc {
    [super dealloc];
}



- (void) loadFavorites {
    [favorites removeAllObjects];
    [[self tableView] reloadData];
    
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    if (![lm userLoggedIn]) {
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //NSString* fbSessionId = [defaults objectForKey:@"FBAccessTokenKey"];
    //NSString* fbExpirationDt = [defaults objectForKey:@"FBExpirationDateKey"];
    //NSString* fbId = [defaults objectForKey:@"fbId"];

    
    // Construct URL
    NSURL* url = [NSURL URLWithString:@"http://localhost:8888/barview/index.php/rest/favorites"];
    
    // Construct request object
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //[request addValue:@"dmac" forHTTPHeaderField:@"user_id"];
    //[request addValue:fbSessionId forHTTPHeaderField:@"FbSessionId"];
    //[request addValue:fbExpirationDt forHTTPHeaderField:@"FbExpirationDate"];
    [request addValue:[lm getLogonToken] forHTTPHeaderField:@"User_id"];
    
    
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
    
    // Clear out favorites so we can get the fresh list.
    
    
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    
    // Instruct the parser to start parsing - this is a blocking call.
    [parser parse];
    
    //The parser is done at this point, so release it and reload the table data.
    [parser release];
    [[self tableView] reloadData];
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
    
    NSString* errorString = [NSString stringWithFormat:@"Fetch failed %@", [error localizedDescription]];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:[self tableView]];
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
    if ([elementName isEqualToString:@"name"]) {
        barName = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"address"]) {
        address = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"bar_id"]) {
        barId = [[NSMutableString alloc] init];
    }
}

/**
 * Keep adding characters within a given set of tags as long as there are more characters.
 */
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([parseState isEqualToString:@"name"]) {
        [barName appendString:string];
    }
    else if([parseState isEqualToString:@"address"]) {
        [address appendString:string];
    }
    else if([parseState isEqualToString:@"bar_id"]) {
        [barId appendString:string];
    }
}

/**
 * We've found an end tag.  However, we only want to add an entry to the table when the whole
 * XML entity for a single bar has been parsed.  We know this occurs when we process a 
 * </com.barview.rest.Favorite> tag.
 */
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"Processing end tag %@", elementName);
    if ([elementName isEqualToString:@"favorite"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
        
        Bar* b = [[Bar alloc] init];
        [b setBarId:[[NSString alloc] initWithString:barId]];
        [b setName:[[NSString alloc] initWithString:barName]];
        [b setAddr:[[NSString alloc] initWithString:address]];
        [b setCity:@"Medfield"];
        [b setState:@"MA"];
        [b setZip:@"02052"];
        
        [favorites addObject:b];
        [faves setValue:[[NSString alloc] initWithString:barName] forKey:[[NSString alloc] initWithString:barId]];
        [b release];
        
        [barName release];
        barName = nil;
        
        [address release];
        address = nil;
        
        [barId release];
        barId = nil;
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"ERROR PARSING XML: %@", [parseError localizedDescription]);
}


@end
