//
//  LoginManagerFactory.m
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "LoginManagerFactory.h"

static FacebookLoginManager* facebookLoginManager;

@implementation LoginManagerFactory

+ (BaseLoginManager*) getLoginManager {
    if (!facebookLoginManager) {
        facebookLoginManager = [[FacebookLoginManager alloc] init];
    }
    
    return facebookLoginManager;
}
@end