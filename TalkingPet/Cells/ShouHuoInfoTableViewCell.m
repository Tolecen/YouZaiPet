//
//  ShouHuoInfoTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/4/8.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ShouHuoInfoTableViewCell.h"

@implementation ShouHuoInfoTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 30)];
        [self.titleL setBackgroundColor:[UIColor clearColor]];
        self.titleL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleL];
        
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 7, ScreenWidth-100-10, 35)];
//        self.textView.isScrollable = YES;
//        self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
//        self.textView.minNumberOfLines = 1;
//        self.textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        self.textView.returnKeyType = UIReturnKeyDone; //just as an example
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        self.textView.delegate = self;
//        self.textView.delegate = self;
//        self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        self.textView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textView];
        
        self.placeHolderL = [[UILabel alloc] initWithFrame:CGRectMake(102, 7, ScreenWidth-100-10, 35)];
        self.placeHolderL.backgroundColor = [UIColor clearColor];
        self.placeHolderL.font = [UIFont systemFontOfSize:15];
        self.placeHolderL.textColor = [UIColor colorWithWhite:200/255.0f alpha:1];
        self.placeHolderL.userInteractionEnabled = NO;
        [self.contentView addSubview:self.placeHolderL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.placeHolderL.hidden&&self.textView.text.length>0) {
        self.placeHolderL.hidden = YES;
    }
    if (self.placeHolderL.hidden&&self.textView.text.length<=0) {
        self.placeHolderL.hidden = NO;
    }
}
- (void)textViewDidChange:(UITextView *)theTextView
{
    if (!self.placeHolderL.hidden&&theTextView.text.length>0) {
        self.placeHolderL.hidden = YES;
    }
    if (self.placeHolderL.hidden&&theTextView.text.length<=0) {
        self.placeHolderL.hidden = NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//}

#pragma mark -
#pragma mark HPExpandingTextView delegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{

    
    return YES;
}
//改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    if ([self.delegate respondsToSelector:@selector(heightChanged:text:cellIndex:)]) {
        [self.delegate heightChanged:height text:self.textView.text cellIndex:self.cellIndex];
    }
}

//-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
////    if ([text isEqualToString:@"\n"]) {
////        return NO;
////    }
////    return YES;
//}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
