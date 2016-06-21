//
//  NetServe.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import "AFNetworking.h"
#import "RNCryptor.h"
#import "RNEncryptor.h"
#import "UIDevice+IdentifierAddition.h"
#import "JSON.h"
#import "SFHFKeychainUtils.h"
#import "RNDecryptor.h"
#import "ShareServe.h"
static inline NSString * gen_uuid()

{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    
    CFRelease(uuid_ref);
    
    NSString *uuid =  [[NSString  alloc]initWithCString:CFStringGetCStringPtr(uuid_string_ref, 0) encoding:NSUTF8StringEncoding];
    
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}
@class TFileManager;
@interface NetServer : NSObject<UIAlertViewDelegate>
+(NSMutableDictionary *)commonDict;
+(void)requestWithParameters:(NSDictionary *)parameters Controller:(UIViewController *)controller success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)requestWithParameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)requestWithEncryptParameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadFile:(NSData*)fileData withUpLoadPath:(NSString *)path fileType:(NSString*)type ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;//type:jpg\wav\amr

+(void)uploadImage:(UIImage *)uploadImage Type:(NSString *)imgType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
           failure:(void (^)(NSError *error))failure;
+(void)uploadAudio:(NSData *)audioData Type:(NSString *)audioType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
           failure:(void (^)(NSError *error))failure;

+(void)uploadAudio:(NSData *)audioData MsgId:(NSString *)msgId Type:(NSString *)audioType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
           failure:(void (^)(NSError *error))failure;

+(void)uploadShuoShuoWithImage:(UIImage *)uploadImage ThumImg:(UIImage *)thumbImg Audio:(NSData *)audioData ContentDict:(NSMutableDictionary *)contentDict Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
                       failure:(void (^)(NSError *error))failure;
+(void)downloadZipFileWithUrl:(NSString *)zipUrl ZipName:(NSString *)zipName Success:(void (^)(NSString * zipfileName))success
                      failure:(void (^)(NSError *error))failure;
+(void)downloadAudioFileWithURL:(NSString *)downloadURL TheController:(UIViewController *)controller Success:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)downloadImageFileWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName Success:(void (^)(NSString * imagefileName))success
                        failure:(void (^)(NSError *error))failure;
+(void)downloadCommonImageFileWithUrl:(NSString *)imageUrl Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
+(void)saveFailedShuoShuoWithImageData:(NSData *)imgData thumbImgData:(NSData *)thumbImgData AudioData:(NSData *)audioData taskDict:(NSDictionary *)taskDict ContentDict:(NSDictionary *)contentDict;
+(void)getUploadToken;
+(void)getAllMsgCountSuccess:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadFailedShuoShuoWithImage:(UIImage *)uploadImage ThumImg:(UIImage *)thumbImg Audio:(NSData *)audioData ContentDict:(NSMutableDictionary *)contentDict Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success failure:(void (^)(NSError *error))failure;

+(void)uploadImageData:(NSData *)imageData Type:(NSString *)imgType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
               failure:(void (^)(NSError *error))failure;

+(void)getUserInfoById:(NSString *)petId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
