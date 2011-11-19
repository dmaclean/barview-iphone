//
//  BaseLoginManager.h
//  Barview
//
//  Created by Dan MacLean on 11/16/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoginManager.h"

@interface BaseLoginManager : NSObject <LoginManager> {
    NSString* type;
}

@end
