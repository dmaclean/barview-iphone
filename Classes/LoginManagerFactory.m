//
//  LoginManagerFactory.m
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "LoginManagerFactory.h"


@implementation LoginManagerFactory
+ (BaseLoginManager*) getLoginManager {
    FacebookLoginManager* fbLoginManager = [[[FacebookLoginManager alloc] init] autorelease];
    
    return fbLoginManager;
}
@end