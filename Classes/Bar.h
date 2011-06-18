//
//  Bar.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/30/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Bar : NSObject {
	NSString* name;
	NSString* addr;
	NSString* city;
	NSString* state;
	NSString* zip;
}

@property (nonatomic, assign) NSString* name;
@property (nonatomic, assign) NSString* addr;
@property (nonatomic, assign) NSString* city;
@property (nonatomic, assign) NSString* state;
@property (nonatomic, assign) NSString* zip;

@end
