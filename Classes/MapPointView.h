//
//  MapPointView.h
//  Barview
//
//  Created by Dan MacLean on 6/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "MapPoint.h"


@interface MapPointView : MKPinAnnotationView {
    NSMutableString* barId;
    NSString* barName;
}

@property (nonatomic, retain) NSMutableString* barId;
@property (nonatomic, retain) NSString* barName;

@end
