//
//  FacebookSingleton.h
//  Barview
//
//  Created by Dan MacLean on 7/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"

@interface FacebookSingleton : NSObject {

}
+ (BOOL) userLoggedIn;
+ (NSString*) getLogonToken;
+ (BOOL) hasBarAsFavorite:(NSString*)barId;
+ (void) clearFavorites;

@end
