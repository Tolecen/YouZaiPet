//
//  YZShangChengModel.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "JSONModel.h"

@interface YZShangChengModel : JSONModel

@end

@interface YZDogModel : YZShangChengModel

@end

@interface YZDogDetailModel : YZDogModel

@end

@interface YZQuanSheModel : YZShangChengModel

@end

@interface YZQuanSheDetailModel : YZQuanSheModel

@end

@interface YZGoodsModel : YZShangChengModel

@end

@interface YZGoodsDetailModel : YZGoodsModel

@end
