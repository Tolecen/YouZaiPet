//
//  NSString+CutSpacing.m
//  TalkingPet
//
//  Created by wangxr on 14-10-20.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "NSString+CutSpacing.h"

@implementation NSString (CutSpacing)
-(NSString*)CutSpacing
{
    //暂时去掉，影响英文输入
    //return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString* str = @" [d da fa]     ";
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    return self;
}
+(NSString *)stringWithArray:(NSArray*)arr
{
    NSMutableString * muStr = [[NSMutableString alloc]init];
    for (NSString * str in arr) {
        [muStr appendString:str];
        if (![str isEqualToString:[arr lastObject]]) {
            [muStr appendString:@","];
        }
    }
    return muStr;
}
@end
