//
//  Place.h
//  Around Me
//
//  Created by LTT on 8/13/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface Place : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *address;
- (id) initWithLocation:(CLLocation *) location reference:(NSString *) reference PlaceName:(NSString *) placeName address: (NSString *) address;

@end
