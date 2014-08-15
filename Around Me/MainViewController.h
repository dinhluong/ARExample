//
//  MainViewController.h
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "FlipsideViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic, strong) NSArray *locations;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;


@end
