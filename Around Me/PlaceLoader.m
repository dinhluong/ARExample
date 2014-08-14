//
//  PlaceLoader.m
//  Around Me
//
//  Created by LTT on 8/13/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "PlaceLoader.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSJSONSerialization.h>
#import "Place.h"
NSString *const apiURL = @"https://maps.googleapis.com/maps/api/place/";
NSString *const apiKey = @"AIzaSyDFoGdRdyVe_dcPXHwxgxI9MfOUJWOd3C8";

@interface PlaceLoader()

@property (strong, nonatomic) SuccessHandler successHandler;
@property (strong, nonatomic) ErrorHandler errorHandler;
@property (strong, nonatomic) NSMutableData *responseData;

@end
@implementation PlaceLoader

+ (PlaceLoader *) SharedInstance{
    
    static PlaceLoader *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[PlaceLoader alloc] init];
    });
    return instance;
}

- (void) loadPOIsForLocation:(CLLocation *)location radius:(int)radius SuccessHandler:(SuccessHandler)successHandler ErrorHandle:(ErrorHandler)errorHandler{

    _responseData = nil;
    [self setSuccessHandler:successHandler];
    [self setErrorHandler:errorHandler];
    
    CLLocationDegrees latitude = [location coordinate].latitude;
    CLLocationDegrees longitude = [location coordinate].longitude;
    
    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    [uri appendFormat:@"nearbysearch/json?location=%f,%f&radius=%d&types=establishment&key=%@",latitude,longitude,radius,apiKey];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:YES];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"start connection %@ for request %@",connection,request);
    
}

#pragma mark - NSURLConnection delegate

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    if (_responseData == nil) {
        _responseData = [NSMutableData dataWithData:data];
    }
    else
    {
        [_responseData appendData:data];
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    id Object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
    if (_successHandler) {
        _successHandler(Object);
    }
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_errorHandler) {
        _errorHandler(error);
    }   		

}
- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
	_responseData = nil;
	_successHandler = handler;
	_errorHandler = errorHandler;
    
	NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    
	[uri appendFormat:@"details/json?reference=%@&sensor=true&key=%@", [location reference], apiKey];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
	[request setHTTPShouldHandleCookies:YES];
	[request setHTTPMethod:@"GET"];
    
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	NSLog(@"Starting connection: %@ for request: %@", connection, request);
}
@end
