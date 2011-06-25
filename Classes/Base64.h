//
//  Base64.h
//  Barview
//
//  Created by Dan MacLean on 6/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {
    
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64;
+ (NSString *)encodeBase64WithData:(NSData *)objData;

@end
