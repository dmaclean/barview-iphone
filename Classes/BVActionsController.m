//
//  BVActionsController.m
//  Barview
//
//  Created by Dan MacLean on 11/13/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BVActionsController.h"


@implementation BVActionsController

- (id)initWithStyle:(UITableViewStyle)style
{
    ACTION_CURRLOC = [[NSString alloc] initWithFormat:@"Current location"];
    ACTION_FAVORITES = [[NSString alloc] initWithFormat:@"Favorite bars"];
    ACTION_FINDBARS = [[NSString alloc] initWithFormat:@"Find bars on map"];
    ACTION_LOGIN = [[NSString alloc] initWithFormat:@"Log in"];
    ACTION_LOGOUT = [[NSString alloc] initWithFormat:@"Log out"];
    
    currentLocation = [[CurrentLocation alloc] init];
    favoritesController = [[FavoritesController alloc] init];
    loginController = [[DemoAppViewController alloc] init];
    barMapLookup = [[BarMapLookup alloc] init];

    
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Barview"];
        
        bvActions = [[NSMutableArray alloc] init];
        
        [bvActions addObject:[[NSString alloc] initWithFormat:@"%@",ACTION_FINDBARS]];
        [bvActions addObject:[[NSMutableString alloc] initWithFormat:@"%@", ACTION_CURRLOC]];
        
        if ([FacebookSingleton userLoggedIn]) {
            [bvActions addObject:[[NSMutableString alloc] initWithFormat:@"%@", ACTION_FAVORITES]];
            [bvActions addObject:[[NSMutableString alloc] initWithFormat:@"%@", ACTION_LOGOUT]];
        }
        else {
            [bvActions addObject:[[NSMutableString alloc] initWithFormat:@"%@", ACTION_LOGIN]];
        }
    }
    return self;
}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [bvActions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSMutableString* action = [bvActions objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:action];
    
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
/**
 * Determine which Controller to present the user with depending on which table
 * row they selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* selection = [bvActions objectAtIndex:[indexPath row]];
    if ([selection isEqualToString:ACTION_CURRLOC]) {
        [[self navigationController] pushViewController:currentLocation animated:YES];
    }
    else if ([selection isEqualToString:ACTION_FAVORITES]) {
        [[self navigationController] pushViewController:favoritesController animated:YES];
    }
    else if ([selection isEqualToString:ACTION_FINDBARS]) {
        [[self navigationController] pushViewController:barMapLookup animated:YES];
    }
    else if ([selection isEqualToString:ACTION_LOGIN] || [selection isEqualToString:ACTION_LOGOUT]) {
        [[self navigationController] pushViewController:loginController animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Available Options";
}

@end
