//
//  NSMutableArray+Asset.m
//  TalkingPet
//
//  Created by wangxr on 15/3/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "NSMutableArray+Asset.h"

@implementation NSMutableArray (Asset)
-(BOOL)containsAsset:(ALAsset *)asset
{
    for (id obj in self) {
        if ([obj isKindOfClass:[ALAsset class]]&&[[(ALAsset*)obj defaultRepresentation].filename isEqualToString:[asset defaultRepresentation].filename]) {
            NSLog(@"%@==%@",[(ALAsset*)obj defaultRepresentation].filename,[asset defaultRepresentation].filename);
            return YES;
        }
    }
    return NO;
}
-(void)removeAsset:(ALAsset *)asset
{
    for (id obj in self) {
        if ([obj isKindOfClass:[ALAsset class]]&&[[(ALAsset*)obj defaultRepresentation].filename isEqualToString:[asset defaultRepresentation].filename]) {
            [self removeObject:obj];
            return;
        }
    }
}
@end
