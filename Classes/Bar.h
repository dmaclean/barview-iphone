//
//  Bar.h
//  Hypnotime
//
//  Created by Dan MacLean on 5/30/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Bar : NSObject {
    NSString* barId;
	NSString* name;
	NSString* addr;
	NSString* city;
	NSString* state;
	NSString* zip;
    
    NSString* latitude;
    NSString* longitude;
}

@property (nonatomic, assign) NSString* barId;
@property (nonatomic, assign) NSString* name;
@property (nonatomic, assign) NSString* addr;
@property (nonatomic, assign) NSString* city;
@property (nonatomic, assign) NSString* state;
@property (nonatomic, assign) NSString* zip;
@property (nonatomic, assign) NSString* latitude;
@property (nonatomic, assign) NSString* longitude;

@end
