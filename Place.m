//
//  Place.m
//  Around Me
//
//  Created by LTT on 8/13/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id) initWithLocation:(CLLocation *)location reference:(NSString *)reference PlaceName:(NSString *)placeName address:(NSString *)address{
    if (self = [super init]) {
        _location = location;
        _reference = reference;
        _placeName = placeName;
        _address = address;
    }
    return self;
}
- (NSString *)infoText {
	return [NSString stringWithFormat:@"Name:%@\nAddress:%@\nPhone:%@\nWeb:%@", _placeName, _address, _phoneNumber, _website];
}
@end
