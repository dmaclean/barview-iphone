//
//  MapPoint.h
//  Whereami
//
//  Created by Dan MacLean on 5/23/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface MapPoint : NSObject <MKAnnotation> {
	NSString *title;
    NSString *subtitle;
    NSMutableString* barId;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSMutableString *barId;

- (id) initWithCoordinate: (CLLocationCoordinate2D) c title:(NSString*) t;

@end
