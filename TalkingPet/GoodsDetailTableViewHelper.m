//
//  GoodsDetailTableViewHelper.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "GoodsDetailTableViewHelper.h"
//#import "EGOImageButton.h"
//@protocol GoodsDetailImageCellDelegate <NSObject>
//@optional
//-(void)resetCellHeightForRow:(NSInteger)index withHeight:(float)height;
//
//@end
//@interface GoodsDetailImageCell : UITableViewCell<EGOImageButtonDelegate>
//@property (nonatomic,retain)EGOImageButton * imageV;
//@property (nonatomic,assign)NSInteger cellIndex;
//@property (nonatomic,assign)BOOL imageLoaded;
//@property (nonatomic,assign)id <GoodsDetailImageCellDelegate> delegate;
//@end
//@implementation GoodsDetailImageCell
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.imageLoaded = NO;
//        self.backgroundColor = [UIColor colorWithWhite:250/255.0f alpha:1];
//        self.contentView.backgroundColor = [UIColor colorWithWhite:250/255.0f alpha:1];
//        self.imageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 0)];
//        [self.contentView addSubview:self.imageV];
//        self.imageV.adjustsImageWhenHighlighted = NO;
//        self.imageV.delegate = self;
//    }
//    return self;
//}
//-(void)imageButtonLoadedImage:(EGOImageButton *)imageButton
//{
//    UIImage * img = imageButton.currentImage;
//    if (!img&&self.imageLoaded) {
//        return;
//    }
//    self.imageLoaded = YES;
//    float height = (ScreenWidth-20)*img.size.height/img.size.width;
//    [self.imageV setFrame:CGRectMake(10, 10, ScreenWidth-20, height)];
//    if ([self.delegate respondsToSelector:@selector(resetCellHeightForRow:withHeight:)]) {
//        [self.delegate resetCellHeightForRow:self.cellIndex withHeight:(height+10)];
//    }
//}
//@end

@interface GoodsDetailTableViewHelper ()
@property (nonatomic,strong) UIView * imageBgV;
@property (nonatomic,strong) NSArray * picArray;
@property (nonatomic,strong) NSMutableArray * heightArray;

@end
@implementation GoodsDetailTableViewHelper
-(id)initWithTableview:(UIView *)bgv PicArray:(NSArray *)array
{
    if (self = [super init]) {
        
  
        
        self.imageBgV = bgv;
        
        UILabel * g = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        g.backgroundColor = [UIColor clearColor];
        g.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        g.font = [UIFont boldSystemFontOfSize:14];
        g.text = @"商品详情";
        [self.imageBgV addSubview:g];
        
        self.imageBgV.backgroundColor = [UIColor colorWithWhite:250/255.0f alpha:1];
//        self.tableView.backgroundView = nil;
        self.picArray = array;
        self.heightArray = [NSMutableArray array];
        for (int i = 0; i<self.picArray.count; i++) {
            [self.heightArray addObject:[NSNumber numberWithFloat:10]];
        }
        for (int i = 0; i<self.picArray.count; i++) {
            EGOImageButton * imageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10+i*10, ScreenWidth-20, 10)];
            [self.imageBgV addSubview:imageV];
            imageV.userInteractionEnabled = NO;
            imageV.tag = i+1;
            
            imageV.delegate = self;
//            imageV.imageURL = [NSURL URLWithString:[self.picArray[i] objectForKey:@"pic"]];
            
            
        }
        
    }
    return self;
}
-(void)loadContent
{
    for (int i = 0; i<self.picArray.count; i++) {
        EGOImageButton * imageV = (EGOImageButton *)[self.imageBgV viewWithTag:i+1];
        imageV.imageURL = [NSURL URLWithString:[self.picArray[i] objectForKey:@"pic"]];
        
        
    }
}
-(void)imageButtonLoadedImage:(EGOImageButton *)imageButton
{
    UIImage *img = imageButton.currentImage;
    if (img) {
        float height = (ScreenWidth-20)*img.size.height/img.size.width;
        [self.heightArray replaceObjectAtIndex:imageButton.tag-1 withObject:[NSNumber numberWithFloat:height]];
//        imageButton.frame = CGRectMake(0, 0, ScreenWidth-20, height);
        float originY = 30;
        for (int i = 0; i<self.picArray.count; i++) {
            EGOImageButton*g = (EGOImageButton *)[self.imageBgV viewWithTag:i+1];
            [g setFrame:CGRectMake(g.frame.origin.x, 10*(i+1)+originY, ScreenWidth-20, g.tag==imageButton.tag?height:g.frame.size.height)];
            originY = originY+[self.heightArray[i] floatValue];
            
           
        }
        
        float allH = 30;
        for (int i = 0; i<self.picArray.count; i++) {
            allH = allH + [self.heightArray[i] floatValue];
        }
        [self.imageBgV setFrame:CGRectMake(self.imageBgV.frame.origin.x, self.imageBgV.frame.origin.y, ScreenWidth, allH+10*self.picArray.count)];
        
        if ([self.delegate respondsToSelector:@selector(resetContentSize)]) {
            [self.delegate resetContentSize];
        }
    }
}
//-(void)resetCellHeightForRow:(NSInteger)index withHeight:(float)height
//{
//    [self.heightArray replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:height]];
//    float h = 0;
//    for (int i = 0; i<self.heightArray.count; i++) {
//        h = h + [self.heightArray[i] floatValue];
//    }
//    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, ScreenWidth, h);
//    NSLog(@"theHHHHeight:%f",h);
//    [self.tableView reloadData];
//    if ([self.delegate respondsToSelector:@selector(resetContentSize)]) {
//        [self.delegate resetContentSize];
//    }
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.picArray.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.heightArray[indexPath.row] floatValue];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *goodsimagevCellIdentifier = @"goodsimagevcell";
//    GoodsDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsimagevCellIdentifier];
//    if (cell == nil) {
//        cell = [[GoodsDetailImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsimagevCellIdentifier];
//        cell.delegate = self;
//    }
//    cell.cellIndex = indexPath.row;
//    cell.imageV.imageURL = [NSURL URLWithString:[self.picArray[indexPath.row] objectForKey:@"pic"]];
//    
//    return cell;
//}

@end
