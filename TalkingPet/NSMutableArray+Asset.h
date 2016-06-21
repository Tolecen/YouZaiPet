//
//  NSMutableArray+Asset.h
//  TalkingPet
//
//  Created by wangxr on 15/3/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NSMutableArray (Asset)
-(BOOL)containsAsset:(ALAsset *)asset;
-(void)removeAsset:(ALAsset *)asset;
@end
