//
//  FlipsideViewController.h
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ARKit.h"
#import "MarkerView.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController<ARLocationDelegate, ARMarkerDelegate, ARDelegate,MarkerViewDelegate>

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) MKUserLocation *userLocation;
@property (strong, nonatomic) AugmentedRealityController *arController;
@property (strong, nonatomic) NSMutableArray *geoLocations;
- (IBAction)done:(id)sender;

@end
