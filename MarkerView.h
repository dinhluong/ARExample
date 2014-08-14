//
//  MarkerView.h
//  Around Me
//
//  Created by LTT on 8/14/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARGeoCoordinate;

@protocol MarkerViewDelegate;

@interface MarkerView : UIView <MarkerViewDelegate>

@property (strong, nonatomic) ARGeoCoordinate *coordinate;
@property (weak, nonatomic) id <MarkerViewDelegate> delegate;

- (id)initWithCoordinate:(ARGeoCoordinate*)coordinate delegate:(id<MarkerViewDelegate>) delegate;

@end

@protocol MarkerViewDelegate <NSObject>

- (void) didTouchMarkerView: (MarkerView*) markerView;

@end