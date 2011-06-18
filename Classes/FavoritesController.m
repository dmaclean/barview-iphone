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
		UITabBarItem* tbi = [self tabBarItem];
		[tbi setTitle:@"Favorite Bars"];
		
		favorites = [[NSMutableArray alloc] init];
		for (int i=0; i<5; i++) {
			Bar* b = [[Bar alloc] init];
			[b setName:@"Test %d"];
			[b setAddr:@"1 Main St"];
			[b setCity:@"Medfield"];
			[b setState:@"MA"];
			[b setZip:@"02052"];
			
			[favorites addObject:b];
			[b release];
		}
		
		// Set the nav bar with the edit button
		[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
		
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
	
	// Are we deleting?
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Remove the row from the data source
		[favorites removeObjectAtIndex:[indexPath row]];
		
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


@end
