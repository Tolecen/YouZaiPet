//
//  OpenImageViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/16.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "OpenImageViewController.h"

@interface OpenImageViewController ()

@end

@implementation OpenImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *openImgDirectory = [documentsw stringByAppendingPathComponent:@"OpenImages"];
    BOOL isDirss2 = FALSE;
    BOOL isDirExistss2 = [[NSFileManager defaultManager] fileExistsAtPath:openImgDirectory isDirectory:&isDirss2];
    
    if (!(isDirExistss2 && isDirss2))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:openImgDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        NSArray * pathArr = [[NSFileManager defaultManager] subpathsAtPath:openImgDirectory];
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:self.view.frame];
        NSString * path = [openImgDirectory stringByAppendingPathComponent:pathArr[0]];
        UIImage * image = [UIImage imageWithContentsOfFile:path];
        [imageV setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*(image.size.height/image.size.width))];
        [imageV setImage:image];
        [self.view addSubview:imageV];
    }
    [self performSelector:@selector(back) withObject:nil afterDelay:3];
    // Do any additional setup after loading the view.
}
- (void)back
{
    //    [SystemServer sharedSystemServer].canPlayAudio = YES;
    self.navigationController.navigationBarHidden = NO;

    [UIView animateWithDuration:1 animations:^{
        [self.view setAlpha:0];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
