//
//  PlaceLoader.h
//  Around Me
//
//  Created by LTT on 8/13/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class Place;
typedef void(^SuccessHandler)(NSDictionary *responseDict);
typedef void(^ErrorHandler)(NSError *error);

@interface PlaceLoader : NSObject<NSURLConnectionDataDelegate>

+ (PlaceLoader *) SharedInstance;

- (void) loadPOIsForLocation: (CLLocation *) location radius:(int)radius SuccessHandler:(SuccessHandler)successHandler ErrorHandle:(ErrorHandler) errorHandler;

- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;
@end
