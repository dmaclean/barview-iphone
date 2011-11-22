//
//  BarviewURLUtility.m
//  Barview
//
//  Created by Dan MacLean on 11/19/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "BarviewURLUtility.h"

static NSString* LOCAL       = @"LOCAL";
static NSString* DEV         = @"DEV";
static NSString* DEMO        = @"DEMO";
static NSString* PROD        = @"PROD";
static NSString* environment = @"";

@implementation BarviewURLUtility

/**
 * Set the environment flag to the env we want to send requests to.
 */
+(void) initialize {
    environment = LOCAL;
}

/**
 * URL for the favorites REST service, which serves GET requests for all of a user's favorite bars.
 */
+ (NSString*) getFavoritesURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/rest/favorites";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/rest/favorites";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/rest/favorites";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/rest/favorites";
    }
    return @"";
}

/**
 * URL for the favorite REST service, which serves POST and DELETE requests for a single favorite.
 */
+ (NSString*) getFavoriteURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/rest/favorite";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/rest/favorite";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/rest/favorite";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/rest/favorite";
    }
    return @"";
}

/**
 * URL to query for nearby bars of a particular latitude/longitude pair.
 */
+ (NSString*) getNearbyBarsURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/rest/nearbybars";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/rest/nearbybars";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/rest/nearbybars";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/rest/nearbybars";
    }
    return @"";
}

/**
 * URL to serve GET requests for a particular bar.
 */
+ (NSString*) getBarImageURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/rest/barimage";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/rest/barimage";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/rest/barimage";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/rest/barimage";
    }
    return @"";
}

/**
 * URL to facilitate logging Barview (not Facebook) users in.
 */
+ (NSString*) getBarviewLoginURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/mobilelogin";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/mobilelogin";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/mobilelogin";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/mobilelogin";
    }
    return @"";
}

/**
 * URL to facilitate logging mobile Barview users out.
 */
+ (NSString*) getBarviewLogoutURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/mobilelogin/logout";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/mobilelogin/logout";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/mobilelogin/logout";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/mobilelogin/logout";
    }
    return @"";
}

/*
 * URL to facilitate fetching deals for a user.
 */
+ (NSString*) getDealsURLForRunMode {
    if (environment == LOCAL) {
        return @"http://localhost:8888/barview/index.php?/rest/events";
    }
    else if (environment == DEV) {
        return @"http://dev.bar-view.com/index.php?/rest/events";
    }
    else if (environment == DEMO) {
        return @"http://demo.bar-view.com/index.php?/rest/events";
    }
    else if (environment == PROD) {
        return @"http://bar-view.com/index.php?/rest/events";
    }
    return @"";
}

+ (NSString*) getLocalString {
    return LOCAL;
}

+ (NSString*) getDevString {
    return DEV;
}

+ (NSString*) getDemoString {
    return DEMO;
}

+ (NSString*) getProdString {
    return PROD;
}

+ (NSString*) getEnvironment {
    return environment;
}

+ (void) setEnvironment:(NSString *)env {
    environment = env;
}

@end
