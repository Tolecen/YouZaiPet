//
//  TFileManager.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-24.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TFileManager.h"
#import "ZipArchive.h"
@implementation TFileManager
+(void)copyFileFromBundleToDocuments:(NSArray *)filesNameArray
{
    dispatch_queue_t queue = dispatch_queue_create("com.pet.copyfiles", NULL);
    dispatch_async(queue, ^{
        for (int i = 0; i<filesNameArray.count; i++) {
            NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *subdirectoryws = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
            BOOL isDirss = FALSE;
            BOOL isDirExistss = [[NSFileManager defaultManager] fileExistsAtPath:subdirectoryws isDirectory:&isDirss];
            
            
            if (!(isDirExistss && isDirss))
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:subdirectoryws withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"Audios"];
            BOOL isDirs = FALSE;
            BOOL isDirExists = [[NSFileManager defaultManager] fileExistsAtPath:subdirectoryw isDirectory:&isDirs];
            
            
            if (!(isDirExists && isDirs))
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:subdirectoryw withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            


            
            
            BOOL success;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *subdirectory = [documentsDirectory stringByAppendingPathComponent:@"Accessorys"];
            


            NSString *writableFilePath = [subdirectory stringByAppendingPathComponent:filesNameArray[i]];
            success = [fileManager fileExistsAtPath:writableFilePath];
            
            NSString *theFilePathDirect = [subdirectory stringByAppendingPathComponent:[filesNameArray[i] substringToIndex:([filesNameArray[i] length]-4)]];
            
            BOOL isDir = FALSE;
            BOOL isDirExist = [fileManager fileExistsAtPath:theFilePathDirect isDirectory:&isDir];
            
            
            if (!success&&!(isDirExist && isDir))
            {
                [fileManager createDirectoryAtPath:subdirectory withIntermediateDirectories:YES attributes:nil error:nil];
                NSString *defaultFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filesNameArray[i]];
                success = [fileManager copyItemAtPath:defaultFilePath toPath:writableFilePath error:&error];
                if (!success) {
                    NSLog(0, @"Failed to copy file to documents with message '%@'.", [error localizedDescription]);
                }
                else
                {
                    NSLog(@"copyed %@ to %@",filesNameArray[i],writableFilePath);
                }
//                [fileManager removeItemAtPath:defaultFilePath error:nil];

            }
            else
                NSLog(@"already exsit %@",writableFilePath);
            
            if(!(isDirExist && isDir))
            {
                NSLog(@"no %@",theFilePathDirect);
                if ([filesNameArray[i] hasSuffix:@"zip"]) {
                    [self unZipFile:filesNameArray[i]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            
        });
    });
}
+(BOOL)ifExsitFolder:(NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *subdirectory = [documentsDirectory stringByAppendingPathComponent:@"Accessorys"];
    NSString *theFilePathDirect = [subdirectory stringByAppendingPathComponent:folderName];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:theFilePathDirect isDirectory:&isDir];
    return isDir&&isDirExist;
}
+(BOOL)ifExsitFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *subdirectory = [documentsDirectory stringByAppendingPathComponent:@"Accessorys"];
    
    NSString *writableFilePath = [subdirectory stringByAppendingPathComponent:fileName];
    BOOL success = [fileManager fileExistsAtPath:writableFilePath];
    return success;
}
+(BOOL)ifExsitAudio:(NSString *)fileName
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
//    BOOL isDir = FALSE;
//    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:subdirectory isDirectory:&isDir];
//    
//    
//    if (!(isDirExist && isDir))
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:subdirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    NSString *audioPath = [subdirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:audioPath];

}
+(void)unZipFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *subdirectory = [documentsDirectory stringByAppendingPathComponent:@"Accessorys"];
    
    NSString *zipPath = [subdirectory stringByAppendingPathComponent:fileName];
    if([fileManager fileExistsAtPath:zipPath])
    {
        ZipArchive * zc = [[ZipArchive alloc] initWithFileManager:fileManager];
        if ([zc UnzipOpenFile:zipPath]) {
            NSLog(@"%@ unzip success!!",zipPath);
            if ([zc UnzipFileTo:subdirectory overWrite:YES]) {
                NSLog(@"%@ write success!!",zipPath);
            }
            else
                NSLog(@"%@ write failed!!",zipPath);
            [zc UnzipCloseFile];
            [fileManager removeItemAtPath:zipPath error:nil];
        }
        else
            NSLog(@"%@ unzip failed!!",zipPath);
    }
}
+(NSArray*)getAllImagesWithID:(NSString*)accessoryID
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *accessorys = [[documents stringByAppendingPathComponent:@"Accessorys"] stringByAppendingPathComponent:accessoryID];
    NSArray * pathArr = [[NSFileManager defaultManager] subpathsAtPath:accessorys];
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * fileName in pathArr) {
        NSString * path = [accessorys stringByAppendingPathComponent:fileName];
        UIImage * image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [array addObject:image];
        }
    }
    return array;
}
+(UIImage*)getFristImageWithID:(NSString*)accessoryID
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *accessorys = [[documents stringByAppendingPathComponent:@"Accessorys"] stringByAppendingPathComponent:accessoryID];
    NSString * path = [accessorys stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_1.png",accessoryID]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    return image;
}
+(UIImage*)getImageWithID:(NSString*)accessoryID
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *accessorys = [documents stringByAppendingPathComponent:@"Accessorys"];
    NSString * path = [accessorys stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",accessoryID]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    return image;
}
+(void)deleteSoundCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *audios = [documents stringByAppendingPathComponent:@"Audios"];
    NSArray * pathArr = [[NSFileManager defaultManager] subpathsAtPath:audios];
    for (NSString * fileName in pathArr) {
        NSString * path = [audios stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:path error:NULL];
    }
}
+ (float)allCacheSize
{
    long long folderSize = 0;
    NSFileManager* manager = [NSFileManager defaultManager];
    
    NSString* EGOCachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
	EGOCachePath = [[[EGOCachePath stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"EGOCache"] copy];
    if ([manager fileExistsAtPath:EGOCachePath]){
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:EGOCachePath] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [EGOCachePath stringByAppendingPathComponent:fileName];
            folderSize += ({
                float addSize = 0;
                if ([manager fileExistsAtPath:fileAbsolutePath]){
                    addSize = [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
                }
                addSize;
            });
        }
    }
    
    NSString *audiosPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    audiosPath = [audiosPath stringByAppendingPathComponent:@"Audios"];
    if ([manager fileExistsAtPath:audiosPath]){
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:audiosPath] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [audiosPath stringByAppendingPathComponent:fileName];
            folderSize += ({
                float addSize = 0;
                if ([manager fileExistsAtPath:fileAbsolutePath]){
                    addSize = [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
                }
                addSize;
            });
        }
    }
    return folderSize/(1024.0*1024.0);
}
@end
