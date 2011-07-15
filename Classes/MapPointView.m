//
//  MapPointView.m
//  Barview
//
//  Created by Dan MacLean on 6/24/11.
//  Copyright 2011 UMass Dartmouth. All rights reserved.
//

#import "MapPointView.h"


@implementation MapPointView

@synthesize barId, barName;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ([annotation isMemberOfClass:[MapPoint class]]) {
        NSMutableString* bar_id = [(MapPoint*) annotation barId];
        NSMutableString* title = [[NSMutableString alloc] initWithFormat:@"%@", [annotation title]];
        NSLog(@"BAR TITLE: %@", title);
        [self setBarId:bar_id];
        [self setBarName:title];
    }
    
    return self;
}

/*- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(60.0, 85.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(30.0, 42.0);
    }
    return self;
}*/

/*- (void)setAnnotation:(id <MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}*/

@end
