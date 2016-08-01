//
//  TFileManager.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-24.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFileManager : NSObject
+(void)copyFileFromBundleToDocuments:(NSArray *)filesNameArray;
+(BOOL)ifExsitFolder:(NSString *)folderName;
+(BOOL)ifExsitFile:(NSString *)fileName;
+(void)unZipFile:(NSString *)fileName;
+(NSArray*)getAllImagesWithID:(NSString*)accessoryID;//其实是文件名
+(UIImage*)getFristImageWithID:(NSString*)accessoryID;//其实是文件名
+(UIImage*)getImageWithID:(NSString*)accessoryID;
+(BOOL)ifExsitAudio:(NSString *)fileName;
+(void)deleteSoundCache;
+ (float)allCacheSize;

+(void)writeAddressFile:(NSData *)data;
+(NSDictionary *)getAddressDict;
@end
