//
//  MainViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlaceLoader.h"
@interface MainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
    
}

#pragma mark - Location delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    CLLocation *lastLocation = [locations lastObject];
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    NSLog(@"receive location %@ with accuracy %f",lastLocation,accuracy);
    
    if(accuracy < 100)
    {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
        MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
        [_mapView setRegion:region animated:YES];
        [[PlaceLoader SharedInstance] loadPOIsForLocation:[locations lastObject] radius:10000 SuccessHandler:^(NSDictionary *responseDict) {
            NSLog(@"response %@",responseDict);
        } ErrorHandle:^(NSError *error) {
            NSLog(@"Error : %@",error);
        }];
        [manager stopUpdatingLocation];
    }
}
@end
