//
//  BarviewURLUtility.h
//  Barview
//
//  Created by Dan MacLean on 11/19/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarviewURLUtility : NSObject {
    
}

+ (NSString*) getFavoritesURLForRunMode;
+ (NSString*) getFavoriteURLForRunMode;
+ (NSString*) getNearbyBarsURLForRunMode;
+ (NSString*) getBarImageURLForRunMode;
+ (NSString*) getBarviewLoginURLForRunMode;
+ (NSString*) getBarviewLogoutURLForRunMode;

+ (NSString*) getLocalString;
+ (NSString*) getDevString;
+ (NSString*) getDemoString;
+ (NSString*) getProdString;
+ (NSString*) getEnvironment;
+ (void) setEnvironment:(NSString*) env;

@end
