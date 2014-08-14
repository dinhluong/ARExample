//
//  PlaceAnnotation.h
//  Around Me
//
//  Created by LTT on 8/14/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Place;

@interface PlaceAnnotation : NSObject<MKAnnotation>

- (id) initWithPlace:(Place *) place;
- (CLLocationCoordinate2D) coordinate;
- (NSString *) title;

@end
