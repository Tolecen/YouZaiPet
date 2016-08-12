//
//  CommodityModel.m
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "CommodityModel.h"

@implementation CommodityModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if ([key isEqualToString:@"typename"]) {
        _typeName=value;
    }
    
}
-(YZGoodsModel*)replaceCommodityModelToYZGoodsModel:(CommodityModel*)model
{
    YZGoodsModel *yzModel=[[YZGoodsModel alloc] init];
    
    
    
    
    
    
    return yzModel;
    
    
}

//自定义排序方法

-(NSComparisonResult)compareModelUseTime:(CommodityModel
                                          *)model{
    //默认按年龄排序
    NSComparisonResult
    result = [model.addtime compare:self.addtime];//注意:基本数据类型要进行数据转换
    
    //如果添加时间一样就按照名字排序
    if(result == NSOrderedSame) {
        result = [self.name compare:model.name];
    }
    return result;
    
}


-(NSComparisonResult)compareModelSales:(CommodityModel
                                        *)model{
    //默认按年龄排序
    NSComparisonResult
    result = [model.sales compare:self.sales];//注意:基本数据类型要进行数据转换
    
    //如果添加时间一样就按照添加时间排序
    if(result == NSOrderedSame) {
        result = [self.addtime compare:model.addtime];
    }
    return result;
    
}





@end
