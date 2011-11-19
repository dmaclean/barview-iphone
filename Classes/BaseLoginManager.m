//
//  BaseLoginManager.m
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BaseLoginManager.h"


@implementation BaseLoginManager
- (BOOL) userLoggedIn {
    return NO;
}

- (NSString*) getLogonToken {
    return @"";
}

- (NSString*) getType {
    return @"";
}

- (void) setType:(NSString *)type {
    
}

- (BOOL) hasBarAsFavorite:(NSString*) barId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
    
    if ([faves objectForKey:barId])
        return YES;
    
    return NO;
}

- (void) clearFavorites {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
    
    [faves removeAllObjects];
}
@end
