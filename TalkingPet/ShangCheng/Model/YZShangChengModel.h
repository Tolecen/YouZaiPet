//
//  YZShangChengModel.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "JSONModel.h"
#import "YZShangChengConst.h"

@interface YZShangChengModel : JSONModel

@end

@interface YZDogTypeAlphabetModel : YZShangChengModel

@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *dogId;
@property (nonatomic, copy) NSString *typeName;

@end

@protocol YZQuanSheModel <NSObject>
@end

@interface YZQuanSheModel : YZShangChengModel

@property (nonatomic, copy) NSString *shopName;

@end

@interface YZQuanSheDetailModel : YZQuanSheModel

@end


@interface YZDogModel : YZShangChengModel

@property (nonatomic, strong) NSNumber *birthday;

@property (nonatomic, strong) NSNumber *createTime;

@property (nonatomic, copy) NSString *dogId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) long long sellPrice;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, assign, readonly) YZDogSex sex;

@property (nonatomic, copy, readonly) NSString *birthdayString;

@property (nonatomic, copy, readonly) NSString *createString;

@property (nonatomic, assign, readonly) NSInteger birtydayDays;

@property (nonatomic, strong) YZQuanSheModel<YZQuanSheModel> *shop;

@end

@interface YZDogDetailModel : YZDogModel

@end

@interface YZGoodsModel : YZShangChengModel

@end

@interface YZGoodsDetailModel : YZGoodsModel

@end
