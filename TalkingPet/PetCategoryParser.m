//
//  PetCategoryParser.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "PetCategoryParser.h"

@implementation PetCategory
@end
@implementation PetCategoryParser
-(id)init
{
    if (self = [super init]) {
        NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"petCategory"ofType:@"xml"]];
        NSData* data = [[NSData alloc]initWithContentsOfFile:path];
        self.doc = [[GDataXMLDocument alloc] initWithData:data  options:0 error:nil];
        self.rootrootElement = [self.doc rootElement];
        self.allElementsArray = [self.rootrootElement elementsForName:@"node"];
//        NSLog(@"catesArray:%@",self.allElementsArray);
    }
    return self;
}
-(NSArray *)getParentCategorys
{
    NSMutableArray * catesArray = [NSMutableArray array];
    for (GDataXMLElement * element in self.allElementsArray) {
        [catesArray addObject:[[element attributeForName:@"name"] stringValue]];
    }
    return catesArray;
}
-(NSArray *)getBreedsForIndex:(NSInteger)theIndex
{
    NSMutableArray * catesArray = [NSMutableArray array];
    GDataXMLElement * element = [self.allElementsArray objectAtIndex:theIndex];
    NSArray * allnames = [element elementsForName:@"name"];
    for (GDataXMLElement * element in allnames) {
        PetCategory * cat = [PetCategory new];
        cat.name = [element stringValue];
        cat.code = [[element attributeForName:@"id"] stringValue];
        [catesArray addObject:cat];

    }
    return catesArray;
}
- (NSString *)breedWithIDcode:(NSInteger)idcode
{
    if (idcode/1000-1<0) {
        return @"未知";
    }
    NSArray * allnames = [self getBreedsForIndex:idcode/1000-1];
    if (idcode%1000-1 == 998) {
        return ((PetCategory*)[allnames lastObject]).name;
    }
    return ((PetCategory*)allnames[idcode%1000-1]).name;
}
@end
