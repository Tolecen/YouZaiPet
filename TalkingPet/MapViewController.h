//
//  MapViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14-9-1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "TalkingBrowse.h"
#import "TalkingDetailPageViewController.h"
@interface MapViewController : BaseViewController<MKMapViewDelegate>
@property (nonatomic,strong)NSString * thumbImgUrl;
@property (nonatomic,strong)NSString * publisher;
@property (nonatomic,strong)NSString * contentStr;
@property (nonatomic,assign)double lat;
@property (nonatomic,assign)double lon;
@property (nonatomic,strong)TalkingBrowse * talking;
@end
