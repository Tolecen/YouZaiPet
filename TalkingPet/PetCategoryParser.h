//
//  PetCategoryParser.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface PetCategory: NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString* code;

@end
@interface PetCategoryParser : NSObject

@property (nonatomic,strong) GDataXMLDocument *doc;
@property (nonatomic,strong) GDataXMLElement* rootrootElement;
@property (nonatomic,strong) NSArray * allElementsArray;
-(NSArray *)getParentCategorys;
-(NSArray *)getBreedsForIndex:(NSInteger)theIndex;
- (NSString *)breedWithIDcode:(NSInteger)idcode;
@end
