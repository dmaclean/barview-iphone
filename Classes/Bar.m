//
//  Bar.m
//  Hypnotime
//
//  Created by Dan MacLean on 5/30/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "Bar.h"


@implementation Bar
@synthesize barId, name, addr, city, state, zip;

- (id) init {
	[super init];
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

@end
