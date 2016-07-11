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

#pragma mark -- 狗狗类型对象

@protocol YZDogTypeAlphabetModel <NSObject>

@end

@interface YZDogTypeAlphabetModel : YZShangChengModel

@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *dogTypeId;//狗狗类型ID
@property (nonatomic, copy) NSString *typeName;

@end

@protocol YZQuanSheModel <NSObject>
@end

#pragma mark -- 犬舍相关对象

@interface YZQuanSheModel : YZShangChengModel

@property (nonatomic, copy) NSString *shopName;

@end

@interface YZQuanSheDetailModel : YZQuanSheModel

@end

#pragma mark -- 狗狗对象

@protocol YZDogParents <NSObject>

@end

@interface YZDogParents : YZShangChengModel

@property (nonatomic, copy) NSString *parentsId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photos;
@property (nonatomic, assign) YZDogSex sex;
@property (nonatomic, assign) BOOL vaccine;//是否三针疫苗，0为否，1为是

@end

@interface YZDogModel : YZShangChengModel

@property (nonatomic, strong) NSNumber *birthday;

@property (nonatomic, strong) NSNumber *createTime;

@property (nonatomic, copy) NSString *dogId;//狗狗ID

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) long long sellPrice;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, strong) YZQuanSheModel<YZQuanSheModel> *shop;

@property (nonatomic, assign, readonly) YZDogSex sex;

@property (nonatomic, assign, readonly) NSInteger birtydayDays;

@property (nonatomic, copy, readonly) NSString *birthdayString;

@property (nonatomic, copy, readonly) NSString *createString;

@property (nonatomic, assign) BOOL vaccine;//是否三针疫苗，0为否，1为是

@property (nonatomic, strong) YZDogTypeAlphabetModel<YZDogTypeAlphabetModel> *productType;

@end

@interface YZDogDetailModel : YZDogModel

@property (nonatomic, strong) YZDogParents<YZDogParents> *mother;
@property (nonatomic, strong) YZDogParents<YZDogParents> *father;

@end

#pragma mark -- 商品,货物对象

@protocol YZBrandModel <NSObject>
@end

@interface YZBrandModel : YZShangChengModel

@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, copy) NSString *brandId;//品牌ID
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy, readonly) NSString *createString;

@end

@interface YZGoodsModel : YZShangChengModel

@property (nonatomic, strong) YZBrandModel<YZBrandModel> *brand;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *goodsId;//产品ID
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long long sellPrice;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy, readonly) NSString *createString;

@end

@interface YZGoodsDetailModel : YZGoodsModel

@end
