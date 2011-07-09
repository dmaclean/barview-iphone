//
//  MapPoint.m
//  Whereami
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint
@synthesize coordinate, title, subtitle;

- (id) initWithCoordinate:(CLLocationCoordinate2D)c 
					title:(NSString *)t {
	[super init];
	coordinate = c;
	[self setTitle:t];
	return self;
}

- (NSString*) title {
    return title;
}

- (NSString*) subtitle {
    return subtitle;
}

- (void) dealloc {
	[title release];
	[super dealloc];
}

@end
