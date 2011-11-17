//
//  LoginManager.h
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LoginManager <NSObject>
- (BOOL) userLoggedIn;
- (NSString*) getLogonToken;
- (BOOL) hasBarAsFavorite:(NSString*)barId;
- (void) clearFavorites;
@end
