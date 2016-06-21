//
//  LocationManager.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-16.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@end

@implementation LocationManager
static  LocationManager *sharedInstance=nil;

+(LocationManager *) sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
            [sharedInstance initLocation];
           
        }
        return sharedInstance;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)initLocation
{
    lat = 0.0;
    lon = 0.0;
    goUpdate = NO;
    self.locType = @"open";
    needManualFail = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=0.5;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    self.autoCheck = NO;
    self.userPoint=[[CLLocation alloc]initWithLatitude:0 longitude:0];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userPoint = userLocation.location;
    lat = self.userPoint.coordinate.latitude;
    lon = self.userPoint.coordinate.longitude;
    NSLog(@"hhkkkk:%f,%f",[self getLatitude],[self getLongitude]);
    _mapView.showsUserLocation = NO;
    
}
-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{

}
-(void)startCheckLocationWithSuccess:(void(^)(double lat,double lon))success Failure:(void(^)(void))failure
{
    needManualFail = NO;

    [locationManager startUpdatingLocation];
        dispatch_queue_t queue = dispatch_queue_create("com.pet.getLatLon", NULL);
        dispatch_async(queue, ^{
            NSTimeInterval hh = [[NSDate date] timeIntervalSince1970];
            while (true) {
                usleep(100000);
                NSTimeInterval jj = [[NSDate date] timeIntervalSince1970];
                if (lat!=0.0&&lon!=0.0) {
                        success(lat,lon);
                    lat = 0.0;
                    lon = 0.0;
                    break;
                }
                if (needManualFail) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure();

                    });
                    break;
                }
                if (jj-hh>20) {
                    [locationManager stopUpdatingLocation];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure();
                        
                    });
                    break;
                }
            }
        });
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    needManualFail = NO;
    CLLocationCoordinate2D mylocation = newLocation.coordinate;
    LocationM loc;
    loc.lat = mylocation.latitude;
    loc.lng = mylocation.longitude;
    loc=transformFromWGSToGCJ(loc);

    lat = loc.lat;
    lon = loc.lng;
    [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    } 
}
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    needManualFail = YES;
    switch([error code]) {
        case kCLErrorDenied:
        {
            //Access denied by user
            if (!self.autoCheck) {
                errorString = @"请到手机系统的【设置】>【隐私】>【定位服务】中开启宠物说的定位服务";
                //Do something...
                //            if (![self.locType isEqualToString:@"open"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开启定位服务" message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                
            
            }

        }
            break;
        case kCLErrorLocationUnknown:
        {
            //Probably temporary...
            errorString = @"地理位置获取失败,请稍后重试";
//            if (![self.locType isEqualToString:@"open"]) {
        
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
        }
            
//            }
            //Do something else...
            break;
        default:
        {
            errorString = @"地理位置获取失败，请稍后重试";
//            if (![self.locType isEqualToString:@"open"]) {
        
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
        }
            
//            }
            break;
    }


}

-(void)analysisRegionWithLat:(double)theLat Lon:(double)theLon WithSuccess:(void(^)(NSString * address))success Failure:(void(^)(void))failure
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc]initWithLatitude:theLat longitude:theLon];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0)
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             NSString* state = plmark.administrativeArea;
             NSString * subState = plmark.subAdministrativeArea;
             NSString * locality = plmark.locality;
             NSLog(@"%@·%@,%@,%@,%@",state,subState,locality,plmark.subLocality,plmark.subThoroughfare);
             if (locality) {
                 if ((!locality||[locality isKindOfClass:[NSNull class]])&&(plmark.subLocality&&![plmark.subLocality isKindOfClass:[NSNull class]])) {
                     success([NSString stringWithFormat:@"%@",plmark.subLocality]);
                 }
                 else if ((locality&&![locality isKindOfClass:[NSNull class]])&&(!plmark.subLocality||[plmark.subLocality isKindOfClass:[NSNull class]]))
                 {
                     success([NSString stringWithFormat:@"%@",locality]);
                 }
                 else if ((locality&&![locality isKindOfClass:[NSNull class]])&&(plmark.subLocality&&![plmark.subLocality isKindOfClass:[NSNull class]]))
                 {
                     success([NSString stringWithFormat:@"%@·%@",locality,plmark.subLocality]);
                 }
                 else
                 {
                     success(@"未知位置");
                 }
                 
             }
             else
             {
        
                 if ((!state||[state isKindOfClass:[NSNull class]])&&(plmark.subLocality&&![plmark.subLocality isKindOfClass:[NSNull class]])) {
                     success([NSString stringWithFormat:@"%@",plmark.subLocality]);
                 }
                 else if ((state&&![state isKindOfClass:[NSNull class]])&&(!plmark.subLocality||[plmark.subLocality isKindOfClass:[NSNull class]]))
                 {
                     success([NSString stringWithFormat:@"%@",state]);
                 }
                 else if ((state&&![state isKindOfClass:[NSNull class]])&&(plmark.subLocality&&![plmark.subLocality isKindOfClass:[NSNull class]]))
                 {
                     success([NSString stringWithFormat:@"%@·%@",state,plmark.subLocality]);
                 }
                 else
                 {
                     success(@"未知位置");
                 }
             }
             
         }
         else
         {
             failure();
         }
     }];
    
}


-(double)getLatitude
{
    return self.userPoint.coordinate.latitude;
}
-(double)getLongitude
{
    return self.userPoint.coordinate.longitude;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
