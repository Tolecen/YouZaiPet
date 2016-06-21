//
//  MapViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-9-1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MapViewController.h"
#import "JPSThumbnailAnnotation.h"
@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"宠物说位置";
    }
    return self;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(back)];
    // Map View
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    MKCoordinateSpan theSpan;
    
    theSpan.latitudeDelta=0.01;
    
    theSpan.longitudeDelta=0.01;
    
    
    
    
    MKCoordinateRegion theRegion;
    
    theRegion.center=CLLocationCoordinate2DMake(self.lat, self.lon);
    
    theRegion.span=theSpan;
    
    [mapView setRegion:theRegion];
    
    // Annotations
    [mapView addAnnotations:[self generateAnnotations]];
    // Do any additional setup after loading the view.
    [self buildViewWithSkintype];
    
    UILabel * tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth-10, 20)];
    [tL setBackgroundColor:[UIColor clearColor]];
    [tL setText:@"宠物说位置仅供参考"];
    [tL setTextAlignment:NSTextAlignmentRight];
    tL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    tL.font = [UIFont systemFontOfSize:10];
//    tL.shadowColor = [UIColor grayColor];
//    tL.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:tL];
}
- (NSArray *)generateAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Empire State Building
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    empire.imageUrl = self.thumbImgUrl;
    empire.title = self.contentStr.length<1?@"没有描述内容的宠物说":self.contentStr;
    empire.subtitle = self.publisher;
    empire.coordinate = CLLocationCoordinate2DMake(self.lat, self.lon);
    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
    
    
    return annotations;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
//        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
//    }
//    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
//    talkingDV.talking = self.talking;
//    [self.navigationController pushViewController:talkingDV animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
//        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
//    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
