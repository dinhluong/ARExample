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
#import "Place.h"
#import "PlaceAnnotation.h"
@interface MainViewController ()
@property (nonatomic, strong) NSArray *locations;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

@end

@implementation MainViewController

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatitudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";
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
    [[segue destinationViewController] setLocations:_locations];
    [[segue destinationViewController] setUserLocation:[_mapView userLocation]];
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
        [[PlaceLoader SharedInstance] loadPOIsForLocation:[locations lastObject] radius:20 SuccessHandler:^(NSDictionary *responseDict) {
            NSLog(@"response %@",responseDict);
            if ([[responseDict objectForKey:@"status"] isEqualToString:@"OK"]) {
                id places = [responseDict objectForKey:@"results"];
                
                NSMutableArray *temp = [NSMutableArray array];
                
                if ([places isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *result in places ) {
                        float lat = [[result valueForKeyPath:kLatitudeKeypath] floatValue];
                        float lng = [[result valueForKeyPath:kLongitudeKeypath] floatValue];
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lng];
                        Place *currentPlace = [[Place alloc] initWithLocation:location reference:[result valueForKeyPath:kReferenceKey] PlaceName:[result valueForKeyPath:kNameKey] address:[result valueForKeyPath:kAddressKey]];
                        [temp addObject:currentPlace];
                        
                        PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
                        [_mapView addAnnotation:annotation];
                    }
                }
                _locations = [temp copy];
                NSLog(@"locations : %@",locations);
            }
        } ErrorHandle:^(NSError *error) {
            NSLog(@"Error : %@",error);
        }];
        [manager stopUpdatingLocation];
    }
}
@end
