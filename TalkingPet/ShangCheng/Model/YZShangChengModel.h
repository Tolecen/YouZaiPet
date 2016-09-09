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

#pragma mark -- 狗狗对象

@protocol YZDogParents <NSObject>

@end

@interface YZDogParents : YZShangChengModel

@property (nonatomic, copy) NSString *parentsId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photos;
@property (nonatomic, assign) YZDogSex sex;
@property (nonatomic, assign) BOOL vaccine;//是否三针疫苗，0为否，1为是

@property (nonatomic, copy) NSString *boodNo;
@property (nonatomic, copy) NSString *details;

@end

@protocol YZDogImage <NSObject>

@end

@interface YZDogImage : YZShangChengModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;

@end

@protocol YZQuanSheModel <NSObject>
@end
@class YZQuanSheModel;

@interface YZDogModel : YZShangChengModel

@property (nonatomic, strong) NSNumber *birthday;

@property (nonatomic, strong) NSNumber *createTime;

@property (nonatomic, copy) NSString *dogId;//狗狗ID

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) long long sellPrice;
@property (nonatomic, assign) long long specialPrice;
@property (nonatomic, copy) NSString *saleFlag;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString <Optional>*content;

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
@property (nonatomic, copy) NSArray<YZDogImage> *images;

@end

#pragma mark -- 犬舍相关对象

@interface YZQuanSheModel : YZShangChengModel

@property (nonatomic, copy) NSString *shopName;//犬舍名字
@property (nonatomic, copy) NSString *shopAddress;//犬舍地址
@property (nonatomic, copy) NSString *shopId;//犬舍id
@property (nonatomic, copy) NSString *dogIntro;//犬舍介绍
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) long long shopNo;

@property (nonatomic, copy) NSString *sale;//销售数量
@property (nonatomic, copy) NSString *sellCount;//在售数量
@property (nonatomic, copy) NSString *maxPrice;
@property (nonatomic, copy) NSString *minPrice;
@property (nonatomic, copy) NSString *shopKeeper;//主理人

@end

@interface YZQuanSheDetailModel : YZQuanSheModel

@property (nonatomic, assign) float badestScore;
@property (nonatomic, assign) float bestScore;
@property (nonatomic, copy) NSArray<YZDogParents> *dogParents;

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
@property (nonatomic, assign) long long specialPrice;
@property (nonatomic, copy) NSString *saleFlag;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy, readonly) NSString *createString;

@end

@interface YZGoodsDetailModel : YZGoodsModel
@property (nonatomic, copy) NSArray<YZDogImage> *images;
@end

#pragma mark -- 购物车对象

@interface YZShoppingCarModel : YZShangChengModel

@property (nonatomic, copy) NSString *shoppingCarFlag;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL selected;

@end

@interface YZShoppingCarDogModel : YZShoppingCarModel

@property (nonatomic, copy) NSString *dogId;//狗狗ID
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long long sellPrice;
@property (nonatomic, assign) long long specialPrice;
@property (nonatomic, assign) long long originPrice;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) NSInteger birtydayDays;
@property (nonatomic, copy) NSString *birthdayString;
@property (nonatomic, copy) NSString *saleFlag;
@property (nonatomic, assign) YZDogSex sex;

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopThumb;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, assign) long long shopNo;

@end

@interface YZShoppingCarGoodsModel : YZShoppingCarModel

@property (nonatomic, copy) NSString *goodsId;//产品ID
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long long sellPrice;
@property (nonatomic, assign) long long originPrice;
@property (nonatomic, assign) long long specialPrice;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *saleFlag;
@property (nonatomic, copy) NSString *brandName;

@end
