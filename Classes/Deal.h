//
//  Deal.h
//  Barview
//
//  Created by Dan MacLean on 11/21/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Deal : NSObject {
    NSMutableString* barName;
    NSMutableString* detail;
}

@property (nonatomic, retain) NSMutableString* barName;
@property (nonatomic, retain) NSMutableString* detail;

@end
