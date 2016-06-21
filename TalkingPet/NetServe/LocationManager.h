//
//  LocationManager.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-16.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import "ChinaMapShift.h"
@interface LocationManager : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *startPoint;
    //  CLLocationManager *_locationManager;
    MKMapView * _mapView;
    NSTimer * checkTimer;
    float lat;
    float lon;
    BOOL goUpdate;
    
    BOOL needManualFail;
}
@property(nonatomic,strong)CLLocation *userPoint;
@property(nonatomic,strong)NSString *locType;
@property(nonatomic,assign)BOOL autoCheck;
+ (id)sharedInstance;
-(void)initLocation;
-(void)startCheckLocationWithSuccess:(void(^)(double lat,double lon))success Failure:(void(^)(void))failure;
-(double)getLatitude;
-(double)getLongitude;
-(void)analysisRegionWithLat:(double)theLat Lon:(double)theLon WithSuccess:(void(^)(NSString * address))success Failure:(void(^)(void))failure;
@end
