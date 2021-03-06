//
//  LoginManagerFactory.m
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "LoginManagerFactory.h"

static NSString* type = nil;

static NSString* barviewType = @"BARVIEW";
static NSString* facebookType = @"FACEBOOK";

static Facebook* facebook;

static FacebookLoginManager* facebookLoginManager;
static BarviewLoginManager* barviewLoginManager;
static BaseLoginManager* baseLoginManager;

@implementation LoginManagerFactory

+(void)initialize {
    [super initialize];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* t = [defaults valueForKey:@"usertype"];
    if (!t)
        return;
    
    if ([t isEqualToString:barviewType])
        type = barviewType;
    else if ([t isEqualToString:facebookType])
        type = facebookType;
}

+ (BaseLoginManager*) getLoginManager {
    if (type == barviewType) {
        if (!barviewLoginManager) {
            barviewLoginManager = [[BarviewLoginManager alloc] init];
        }
        
        return barviewLoginManager;
    }
    else if (type == facebookType && [facebook isSessionValid]) {
        if (!facebookLoginManager) {
            facebookLoginManager = [[FacebookLoginManager alloc] init];
        }
        
        return facebookLoginManager;
    }
    else {
        if (!baseLoginManager) {
            baseLoginManager = [[BaseLoginManager alloc] init];
        }
        
        return baseLoginManager;
    }
}

+ (NSString*) getBarviewType {
    return barviewType;
}

+ (NSString*) getFacebookType {
    return facebookType;
}

+ (void) setFacebookObject:(Facebook *)fb {
    facebook = fb;
    
    //if ([facebook isSessionValid]) {
    //   type = facebookType;
    //}
}

+ (void) setLoginManagerType:(NSString*) lmType {
    type = lmType;
}
@end