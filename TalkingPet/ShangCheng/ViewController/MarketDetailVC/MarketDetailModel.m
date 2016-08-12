//
//  MarketDetailModel.m
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarketDetailModel.h"

@implementation MarketDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(NSArray *)infoModelWith:(NSDictionary *)dict
{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    for (NSDictionary *dic in dict[@"data"][@"guider"]) {
        MarketDetailModel *model=[[MarketDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        NSMutableArray *mArr=[NSMutableArray array];
        for (NSDictionary *cdict in dic[@"products"]) {
            CommodityModel *cdmodel=[[CommodityModel alloc] init];
            [cdmodel setValuesForKeysWithDictionary:cdict];
            [mArr addObject:cdmodel];
        }
        model.items=mArr;
        [arr addObject:model];
        
        
        
    }
    
    return arr;
}



@end
