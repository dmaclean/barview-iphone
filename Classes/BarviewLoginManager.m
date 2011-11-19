//
//  BarviewLoginManager.m
//  Barview
//
//  Created by Dan MacLean on 11/18/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarviewLoginManager.h"


@implementation BarviewLoginManager

- (BOOL) userLoggedIn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"] )
        return YES;
    
    return NO;
}

- (NSString*) getLogonToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"] )
        return [[[NSString alloc] initWithFormat:@"%@", [defaults objectForKey:@"token"]] autorelease];
    
    return @"";
}

- (NSString*) getType {
    return [LoginManagerFactory getBarviewType];
}

@end
