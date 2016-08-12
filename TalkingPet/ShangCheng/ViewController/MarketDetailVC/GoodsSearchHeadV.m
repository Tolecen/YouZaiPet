//
//  GoodsSearchHeadV.m
//  TalkingPet
//
//  Created by cc on 16/8/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "GoodsSearchHeadV.h"



#define windowContentWidth  ([[UIScreen mainScreen] bounds].size.width)
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 5


@interface  GoodsSearchHeadV()

@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,assign) CGFloat btn_w;



@end


@implementation GoodsSearchHeadV

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _btn_w=0.0;
        
        

        NSArray *titleArray =@[@"最新发布",@"最高人气",@"产品分类"];
        if (titleArray.count<MAX_TitleNumInWindow+1) {
            _btn_w=frame.size.width/titleArray.count;
        }else{
            _btn_w=frame.size.width/MAX_TitleNumInWindow;
        }
        _titles=titleArray;
        _defaultIndex=10000;
        _titleFont=[UIFont systemFontOfSize:13];
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        _titleNomalColor=[UIColor blackColor];
        _titleSelectColor=SFQRedColor;
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count, 0);
        [self addSubview:_bgScrollView];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, _btn_w*titleArray.count, 1)];
        line.backgroundColor=[UIColor lightGrayColor];
        [_bgScrollView addSubview:line];
        
        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2.5, _btn_w/3, 1.5)];
        
        
        
        _selectLine.backgroundColor=[UIColor colorWithRed:0.40 green:0.79 blue:0.69 alpha:1.00];
        [_bgScrollView addSubview:_selectLine];
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-4);
            btn.tag=i+10000;
            
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.00] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment=NSTextAlignmentCenter;
            [btn setTitleColor:[UIColor colorWithRed:0.40 green:0.79 blue:0.69 alpha:1.00] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            
            
            
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.titleLabel.font=_titleFont;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==0) {
                _titleBtn=btn;
                btn.selected=YES;
                CGRect rect = [btn.currentTitle boundingRectWithSize:CGSizeMake(320, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
                
                _selectLine.frame=CGRectMake(_selectLine.frame.origin.x, _selectLine.frame.origin.y, rect.size.width+20, _selectLine.frame.size.height);
                
                CGFloat centerY=_selectLine.center.y;
                _selectLine.center=CGPointMake(btn.center.x, centerY);
                
            }
            if (i==titleArray.count-1) {
                
                [btn setImage:[UIImage imageNamed:@"分类@3x"] forState:UIControlStateNormal];
                btn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
            }
        }
        
    }
    return self;
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.block) {
        self.block(btn.tag-10000);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-windowContentWidth;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    if(btn.tag==[[_btns lastObject] tag])
    {
        _selectLine.hidden=YES;
    }
    else
    {
        _selectLine.hidden=NO;
    }
    [UIView animateWithDuration:.2 animations:^{
        
        CGRect rect = [btn.currentTitle boundingRectWithSize:CGSizeMake(320, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
        
        _selectLine.frame=CGRectMake(_selectLine.frame.origin.x, _selectLine.frame.origin.y, rect.size.width+20, _selectLine.frame.size.height);
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        CGFloat centerY=_selectLine.center.y;
        _selectLine.center=CGPointMake(btn.center.x, centerY);
    } completion:^(BOOL finished) {
        
    }];
    
}



-(void)setTitleNomalColor:(UIColor *)titleNomalColor{
    _titleNomalColor=titleNomalColor;
    [self updateView];
}

-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor=titleSelectColor;
    [self updateView];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont=titleFont;
    [self updateView];
}

-(void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex=defaultIndex;
    [self updateView];
}



-(void)updateView{
    for (UIButton *btn in _btns) {
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font=_titleFont;
        _selectLine.backgroundColor=_titleSelectColor;
        
        if (btn.tag==_defaultIndex) {
            _titleBtn=btn;
            btn.selected=YES;
            
        }else{
            btn.selected=NO;
        }
    }
}


@end
