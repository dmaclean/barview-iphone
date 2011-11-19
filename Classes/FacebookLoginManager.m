//
//  FacebookSingleton.m
//  Barview
//
//  Created by Dan MacLean on 7/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "FacebookLoginManager.h"

@implementation FacebookLoginManager

- (BOOL) userLoggedIn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] )
        return YES;
    
    return NO;
}

- (NSString*) getLogonToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"fbId"] )
        return [[[NSString alloc] initWithFormat:@"fb%@", [defaults objectForKey:@"fbId"]] autorelease];
    
    return @"";
}

- (NSString*) getType {
    return [LoginManagerFactory getFacebookType];
}

@end
