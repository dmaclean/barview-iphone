//
//  FacebookSingleton.m
//  Barview
//
//  Created by Dan MacLean on 7/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "FacebookSingleton.h"


@implementation FacebookSingleton

+ (BOOL) userLoggedIn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] )
        return YES;
    
    return NO;
}

+ (NSString*) getLogonToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"fbId"] )
        return [[[NSString alloc] initWithFormat:@"fb%@", [defaults objectForKey:@"fbId"]] autorelease];
    
    return @"";
}

+ (BOOL) hasBarAsFavorite:(NSString*) barId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
    
    if ([faves objectForKey:barId])
        return YES;

    return NO;
}

+ (void) clearFavorites {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* faves = [defaults objectForKey:@"faves"];
    
    [faves removeAllObjects];
}



@end
