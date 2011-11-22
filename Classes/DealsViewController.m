//
//  DealsViewController.m
//  Barview
//
//  Created by Dan MacLean on 11/21/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "DealsViewController.h"


@implementation DealsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        deals = [[NSMutableArray alloc] init];
        
        dealsForBarsArray = [[NSMutableArray alloc] init];
        
		[[self navigationItem] setTitle:@"Deals and Events"];
    }
    return self;
}

- (void)dealloc
{
    [deals release];
    deals = nil;
    
    [dealsForBarsArray release];
    dealsForBarsArray = nil;
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDeals];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [dealsForBarsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableArray* arr = [dealsForBarsArray objectAtIndex:section];
    return [arr count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray* arr = [dealsForBarsArray objectAtIndex:section];
    Deal* d = [arr objectAtIndex:0];
    return [d barName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSMutableArray* arr = [dealsForBarsArray objectAtIndex:[indexPath section]];
    Deal* d = [arr objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[d detail]];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    NSMutableArray* arr = [dealsForBarsArray objectAtIndex:[indexPath section]];
    Deal* d = [arr objectAtIndex:[indexPath row]];
    
    NSString* message = [NSString stringWithFormat:@"%@", [d detail]];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:message delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet autorelease];
    [actionSheet showInView:[self view]];
}

- (void) loadDeals {
    [deals removeAllObjects];
    
    // We shouldn't even be here if the user isn't logged in.
    BaseLoginManager* lm = [LoginManagerFactory getLoginManager];
    if (![lm userLoggedIn]) {
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    // Construct URL
    NSURL* url = [NSURL URLWithString:[BarviewURLUtility getDealsURLForRunMode]];
    
    // Construct request object
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    if ([lm getType] == [LoginManagerFactory getBarviewType]) {
        [request addValue:[defaults objectForKey:@"email"] forHTTPHeaderField:@"User_id"];
    }
    else if ([lm getType] == [LoginManagerFactory getFacebookType]) {
        NSString* fbId = [defaults objectForKey:@"fbId"];
        NSString* userId = [NSString stringWithFormat:@"fb%@", fbId];
        [request addValue:userId forHTTPHeaderField:@"User_id"];
    }
    
    
    
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



/*************************
 * CONNECTION CALLBACKS
 ************************/
/**
 * Append data to the structure that holds deals as the data comes in.
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
    
    /*
     * Iterate through the results and group the deals for each bar.  There is an array
     * dealsForBarsArray that contains arrays of Deal objects - with each array being all
     * the deals for a single bar.
     */
    [dealsForBarsArray removeAllObjects];
    for (Deal* d in deals) {
        // Haven't seen this bar yet.  Create an array and put the Deal reference in it, then
        // Add the new array to our dealsForBars dictionary under the keyname of the bar name.
        Boolean found = NO;
        for (NSMutableArray* arr in dealsForBarsArray) {
            Deal* currDeal = [arr objectAtIndex:0];
            if ([[currDeal barName] isEqualToString:[d barName]]) {
                [arr addObject:d];
                found = YES;
                break;
            }
        }
        
        if (!found) {
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            [arr addObject:d];
            [dealsForBarsArray addObject:arr];
            [arr release];
        }
    }
    
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
    
    NSString* errorString = [NSString stringWithFormat:@"Unable to get deals and events.  Please try later."];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:[self tableView]];
    [actionSheet autorelease];
}



/**************************
 * XML PARSING CALLBACKS
 *************************/
/**
 * Alerts us that the XML parser has found a new element that it will
 * begin parsing.  In this method we will change the state so we know
 * which string to append data to until the end tag is reached.
 */
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    parseState = [[NSMutableString alloc] initWithString:elementName];
    if ([elementName isEqualToString:@"bar"]) {
        barName = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"detail"]) {
        detail = [[NSMutableString alloc] init];
    }
}

/**
 * Keep adding characters within a given set of tags as long as there are more characters.
 */
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([parseState isEqualToString:@"bar"]) {
        [barName appendString:string];
    }
    else if([parseState isEqualToString:@"detail"]) {
        [detail appendString:string];
    }
}

/**
 * We've found an end tag.  However, we only want to add an entry to the table when the whole
 * XML entity for a single deal has been parsed.  We know this occurs when we process a 
 * </event> tag.
 */
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"Processing end tag %@", elementName);
    if ([elementName isEqualToString:@"event"]) {
        
        Deal* d = [[Deal alloc] init];
        d.barName = barName;
        d.detail = detail;
        
        [deals addObject:d];
        [d release];
        
        [barName release];
        barName = nil;
        
        [detail release];
        detail = nil;
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"ERROR PARSING XML: %@", [parseError localizedDescription]);
}

@end
