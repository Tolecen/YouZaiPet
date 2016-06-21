//
//  NetServe.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "NetServer.h"
#import "TFileManager.h"
#import "SVProgressHUD.h"
#import "NSData-AES.h"
#import "GTMBase64.h"
//#ifndef DevelopModeUU
//
//
//#endif

//#define BaseURL @"http://192.168.3.106:8080/cws-api/servlet?isEncrypt=0&isCompress=0"

@implementation NetServer

+(NSMutableDictionary *)commonDict
{
    NSMutableDictionary * commonDict =[NSMutableDictionary dictionary];
    [commonDict setObject:@"10000000000" forKey:@"sim"];
    [commonDict setObject:Channel forKey:@"channel"];
    [commonDict setObject:CurrentVersion forKey:@"version"];
    [commonDict setObject:DeviceModel forKey:@"model"];
    [commonDict setObject:[@"iOS " stringByAppendingString:SystemVersion] forKey:@"platform"];
    [commonDict setObject:@"0.0.0.0" forKey:@"ipAddr"];
    [commonDict setObject:@"0:0:0:0" forKey:@"macAddr"];
    
    NSString * imeiStr = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        imeiStr = idfa;
        [commonDict setObject:idfa forKey:@"imei"];
//        NSLog(@"IDFAAA:%@",idfa);
    }
    else
    {
        imeiStr = [[UIDevice currentDevice] macaddress];
        [commonDict setObject:imeiStr forKey:@"imei"];
    }
    [commonDict setObject:@"00000000" forKey:@"imsi"];
    
    NSString * dontknowwhat = [SFHFKeychainUtils getPasswordForUsername:@"CHONGWUSHUO" andServiceName:@"CHONGWUSHUOKEYCHAINTOLECENWRITE" error:nil];
    if (dontknowwhat) {
//        [SFHFKeychainUtils deleteItemForUsername:@"CHONGWUSHUO" andServiceName:@"CHONGWUSHUOKEYCHAINTOLECENWRITE" error:nil];
        [commonDict setObject:dontknowwhat forKey:@"keyChain"];
//        NSLog(@" I have the keychain,CHONGWUSHUOKEYCHAINTOLECENWRITE,%@",dontknowwhat);
    }
    else
    {
        NSString * whatstr = [gen_uuid() stringByAppendingString:imeiStr];
//        NSLog(@" I don't have the keychain,CHONGWUSHUOKEYCHAINTOLECENWRITE,but I have written one with password:%@",whatstr);
        [SFHFKeychainUtils storeUsername:@"CHONGWUSHUO" andPassword:whatstr forServiceName:@"CHONGWUSHUOKEYCHAINTOLECENWRITE" updateExisting:YES error:nil];
    }
    
    
    
    return commonDict;
}

+(NSString *)getCurrentImageNameToUpload
{
    NSTimeInterval date = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f.jpg",date];
}
+(void)requestWithParameters:(NSDictionary *)parameters Controller:(UIViewController *)controller success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString * commandStr = [parameters objectForKey:@"command"];
    NSString * reqUrl;
    
    //后台做好白名单之前，暂时用旧的BaseURL
//    reqUrl = BaseURL;
    
    if ([commandStr isEqualToString:@"register"]||[commandStr isEqualToString:@"login"]) {
        reqUrl = BaseURL;
    }
    else{
        reqUrl = BaseUrlO;
        if ([UserServe sharedUserServe].userID) {
            NSString * stoken = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
            if (stoken) {
                reqUrl = [reqUrl stringByAppendingString:stoken];
            }
            else
                reqUrl = [reqUrl substringToIndex:reqUrl.length-8];
        }
        else
            reqUrl = [reqUrl substringToIndex:reqUrl.length-8];
    }
    NSLog(@"request:%@",parameters);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:reqUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (controller) {
            NSString *resText = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary * dict = [resText JSONValue];
            NSLog(@"dict:%@; parameters:%@",dict,parameters);
            if ([[dict objectForKey:@"error"] isEqualToString:@"200"]) {
                if (success) {
                    success(operation,dict);
                }
            }
            else if ([[dict objectForKey:@"error"] isEqualToString:@"503"]) {
                NSError * aError = [NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"error"] integerValue] userInfo:nil];
                if (failure) {
                    failure(operation,aError);
                }
                [NetServer tokenTimeOut];
            }
            else
            {
                NSError * aError = [NSError errorWithDomain:[[dict objectForKey:@"message"] isKindOfClass:[NSString class]]?[dict objectForKey:@"message"]:@"有错，是个字典" code:[[dict objectForKey:@"error"] integerValue] userInfo:nil];
                if (failure) {
                    failure(operation,aError);
                }
            }

        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
        if (failure) {
            failure(operation,error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络请求异常，请确认网络连接正常"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

    
}

+(void)requestWithParameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString * commandStr = [parameters objectForKey:@"command"];
    NSString * reqUrl;
    
    if ([commandStr isEqualToString:@"register"]||[commandStr isEqualToString:@"login"]) {
        reqUrl = BaseURL;
    }
    else{
        reqUrl = BaseUrlO;
        if ([UserServe sharedUserServe].userID) {
            NSString * stoken = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
            if (stoken) {
                reqUrl = [reqUrl stringByAppendingString:stoken];
            }
            else
                reqUrl = [reqUrl substringToIndex:reqUrl.length-8];
        }
        else
            reqUrl = [reqUrl substringToIndex:reqUrl.length-8];
    }
    NSLog(@"request:%@",parameters);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:reqUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       NSData *filData = [responseObject newAESDecryptWithPassphrase:CHONGWUSHUONETPASSWORD];
        NSString *resText = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [resText JSONValue];
        NSLog(@"dict:%@; parameters:%@",dict,parameters);
            if ([[dict objectForKey:@"error"] isEqualToString:@"200"]) {
                if (success) {
                    success(operation,dict);
                }
            }
            else if ([[dict objectForKey:@"error"] isEqualToString:@"503"]) {
                NSError * aError = [NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"error"] integerValue] userInfo:nil];
                if (failure) {
                    failure(operation,aError);
                }
                [NetServer tokenTimeOut];
            }
            else
            {
                NSError * aError = [NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"error"] integerValue] userInfo:nil];
                if (failure) {
                    failure(operation,aError);
                }
            }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
        if (failure) {
            failure(operation,error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络请求异常，请确认网络连接正常"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    
}

+(void)requestWithEncryptParameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"parameters Encrypt:%@",parameters);
    NSString * commandStr = [parameters objectForKey:@"command"];
    NSString * reqUrl;
    if ([commandStr isEqualToString:@"register"]||[commandStr isEqualToString:@"login"]) {
        reqUrl = BaseEncryptURL;
    }
    else{
        reqUrl = BaseEncryptURLO;
        if ([UserServe sharedUserServe].userID) {
            NSString * stoken = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
            if (stoken) {
                reqUrl = [reqUrl stringByAppendingString:stoken];
            }
            else
                reqUrl = [reqUrl stringByAppendingString:@""];
        }
        else
            reqUrl = [reqUrl stringByAppendingString:@""];
    }
    
    NSString * sKey = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    if ([[parameters objectForKey:@"command"] isEqualToString:@"register"]||[[parameters objectForKey:@"command"] isEqualToString:@"login"]) {
        sKey = CHONGWUSHUONETPASSWORD;
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:reqUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    httpClient.isEcrypt = YES;
    [httpClient postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *filData;
        if (sKey) {
            filData = [responseObject newAESDecryptWithPassphrase:sKey];
        }
        else
            filData = responseObject;
        
        NSString *resText = [[NSString alloc] initWithData:filData encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [resText JSONValue];
        if ([[dict objectForKey:@"error"] isEqualToString:@"200"]) {
            if (success) {
                success(operation,dict);
            }
        }
        else if ([[dict objectForKey:@"error"] isEqualToString:@"503"]) {
            NSError * aError = [NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"error"] integerValue] userInfo:nil];
            if (failure) {
                failure(operation,aError);
            }
            [NetServer tokenTimeOut];
        }
        else
        {
            NSError * aError = [NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"error"] integerValue] userInfo:nil];
            if (failure) {
                failure(operation,aError);
            }
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
        if (failure) {
            failure(operation,error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络请求异常，请确认网络连接正常"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    
}

+(void)tokenTimeOut
{
    if ([SystemServer sharedSystemServer].metionTokenOutTime) {
        return;
    }
    [SystemServer sharedSystemServer].metionTokenOutTime = YES;
    NSString * uName = [UserServe sharedUserServe].userName;
    if (uName) {
        if ([uName hasPrefix:@"sina"]) {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        }
    }
    [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    [DatabaseServe unActivateUeser];
    [UserServe sharedUserServe].userName = nil;
    [UserServe sharedUserServe].userID = nil;
    [UserServe sharedUserServe].petArr = nil;
    [UserServe sharedUserServe].currentPet = nil;
    //        [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
    [[SystemServer sharedSystemServer].chatClient logout];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录状态已过期，您需要重新登录" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil, nil];
    alert.tag = 503;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==503) {
    }
}

+(void)uploadImage:(UIImage *)uploadImage Type:(NSString *)imgType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
                       failure:(void (^)(NSError *error))failure
{
    SystemServer * us = [SystemServer sharedSystemServer];
    
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    NSString * imgFileNameToUpload;
    if ([imgType isEqualToString:@"avatar"]) {
        imgFileNameToUpload = [NSString stringWithFormat:@"img/avatar/%@/%@.jpg",pathTime,gen_uuid()];
    }
    else if ([imgType isEqualToString:@"chat"])
    {
        imgFileNameToUpload = [NSString stringWithFormat:@"img/chat/%@/%@.jpg",pathTime,gen_uuid()];
    }
    NSData *imageData  = nil;
    if (uploadImage) {
        imageData = UIImageJPEGRepresentation(uploadImage, 1);
    }
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",imgFileNameToUpload,@"key", nil];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
            NSLog(@"avatar image data size:%lld",(long long)imageData.length);
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject,[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [NetServer getUploadToken];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

+(void)uploadImageData:(NSData *)imageData Type:(NSString *)imgType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
           failure:(void (^)(NSError *error))failure
{
    SystemServer * us = [SystemServer sharedSystemServer];
    
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    NSString * imgFileNameToUpload;
    if ([imgType isEqualToString:@"avatar"]) {
        imgFileNameToUpload = [NSString stringWithFormat:@"img/avatar/%@/%@.jpg",pathTime,gen_uuid()];
    }
    else if ([imgType isEqualToString:@"chat"])
    {
        imgFileNameToUpload = [NSString stringWithFormat:@"img/chat/%@/%@.jpg",pathTime,gen_uuid()];
    }

    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",imgFileNameToUpload,@"key", nil];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
            NSLog(@"avatar image data size:%lld",(long long)imageData.length);
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject,[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [NetServer getUploadToken];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

+(void)uploadAudio:(NSData *)audioData Type:(NSString *)audioType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
           failure:(void (^)(NSError *error))failure
{
    SystemServer * us = [SystemServer sharedSystemServer];
    
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    NSString * audioFileNameToUpload;
    if ([audioType isEqualToString:@"comment"]) {
        audioFileNameToUpload = [NSString stringWithFormat:@"audio/comment/%@/%@.amr",pathTime,gen_uuid()];
    }
    else if ([audioType isEqualToString:@"chat"]){
        audioFileNameToUpload = [NSString stringWithFormat:@"audio/chat/%@/%@.amr",pathTime,gen_uuid()];
    }
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",audioFileNameToUpload,@"key", nil];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (audioData) {
            [formData appendPartWithFileData:audioData name:@"file" fileName:@"temp.amr" mimeType:@"amr"];
            NSLog(@"audio data size:%lld",(long long)audioData.length);
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject,[BaseQiNiuDownloadURL stringByAppendingString:audioFileNameToUpload]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [NetServer getUploadToken];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

+(void)uploadAudio:(NSData *)audioData MsgId:(NSString *)msgId Type:(NSString *)audioType Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success
           failure:(void (^)(NSError *error))failure
{
    SystemServer * us = [SystemServer sharedSystemServer];
    
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    NSString * audioFileNameToUpload;
    if ([audioType isEqualToString:@"comment"]) {
        audioFileNameToUpload = [NSString stringWithFormat:@"audio/comment/%@/%@.amr",pathTime,gen_uuid()];
    }
    else if ([audioType isEqualToString:@"chat"]){
        audioFileNameToUpload = [NSString stringWithFormat:@"audio/chat/%@/%@.amr",pathTime,msgId];
    }
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",audioFileNameToUpload,@"key", nil];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (audioData) {
            [formData appendPartWithFileData:audioData name:@"file" fileName:@"temp.amr" mimeType:@"amr"];
            NSLog(@"audio data size:%lld",(long long)audioData.length);
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject,[BaseQiNiuDownloadURL stringByAppendingString:audioFileNameToUpload]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [NetServer getUploadToken];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

+(void)uploadFile:(NSData*)fileData withUpLoadPath:(NSString *)path fileType:(NSString*)type ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    SystemServer * us = [SystemServer sharedSystemServer];
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",path,@"key", nil];
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSString * fileName = [NSString stringWithFormat:@"temp.%@",type];
    NSString * mimeType = type;
    if ([type isEqualToString:@"jpg"]) {
        mimeType = @"image/jpeg";
    }
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (fileData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
            NSLog(@"image data size:%lld",(long long)fileData.length);
        }
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:block];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [httpClient enqueueHTTPRequestOperation:operation];
}

+(void)uploadShuoShuoWithImage:(UIImage *)uploadImage ThumImg:(UIImage *)thumbImg Audio:(NSData *)audioData ContentDict:(NSMutableDictionary *)contentDict Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success failure:(void (^)(NSError *error))failure
{

    SystemServer * us = [SystemServer sharedSystemServer];
    
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    
    NSString * imgFileNameToUpload = [NSString stringWithFormat:@"img/content/%@/%@.jpg",pathTime,gen_uuid()];
    NSString * audioFileNameToUpload = [NSString stringWithFormat:@"audio/comment/%@/%@.wav",pathTime,gen_uuid()];
    NSString * thumbImgFileNameToUpload = [NSString stringWithFormat:@"img/content/%@/%@.jpg",pathTime,gen_uuid()];
    
    NSString * taskID = imgFileNameToUpload;

    NSData *imageData  = nil;
    if (uploadImage) {
        imageData = UIImageJPEGRepresentation(uploadImage, 0.8);
    }
    NSData *thumbImgData  = nil;
    if (thumbImg) {
        thumbImgData = UIImageJPEGRepresentation(thumbImg, 0.8);
    }
    
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    NSString * thumbImgPath = [NSString stringWithFormat:@"/%@.jpg",gen_uuid()];
    NSString * thumbImgPathN = [subdirectoryw stringByAppendingString:thumbImgPath];
    if ([thumbImgData writeToFile:thumbImgPathN atomically:YES]) {
        NSLog(@"thum img write success");
    }
    else{
        NSLog(@"thum imh write failed");
    }
    
    long long imageDataSize = (long long)imageData.length;
    long long audioDataSize = (long long)audioData.length;
    long long thumbImgDataSize = (long long)thumbImgData.length;
    long long totalDataSize = imageDataSize+audioDataSize+thumbImgDataSize;
    
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    [dicts setObject:taskID forKey:@"taskID"];
    [dicts setObject:[NSString stringWithFormat:@"%f",0.0f/(double)totalDataSize] forKey:@"taskProgress"];
    [dicts setObject:@"taskAdd" forKey:@"taskType"];
    [dicts setObject:@"sending" forKey:@"taskStatus"];
    [dicts setObject:thumbImgPath forKey:@"thumbImgPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dicts];
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",imgFileNameToUpload,@"key", nil];

    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
            NSLog(@"image data size:%lld",(long long)imageData.length);
        }
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:block];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"progress11 %lld of %lld",totalBytesWritten,totalDataSize);
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:taskID forKey:@"taskID"];
        [dict setObject:[NSString stringWithFormat:@"%f",(float)((double)totalBytesWritten/(double)totalDataSize)] forKey:@"taskProgress"];
        [dict setObject:@"taskAdd" forKey:@"taskType"];
        [dict setObject:@"sending" forKey:@"taskStatus"];
        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSDictionary * dict = [receiveStr JSONValue];
        
        NSLog(@"success image upload:%@",[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload]);
//        success(dict,[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload]);
        
        if (thumbImgData) {
            NSDictionary * parameters3 = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",thumbImgFileNameToUpload,@"key", nil];
            
            NSMutableURLRequest *request3 = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters3 constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                if (thumbImgData) {
                    [formData appendPartWithFileData:thumbImgData name:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
                    NSLog(@" thumb image data size:%lld",(long long)thumbImgData.length);
                }
                
            }];
            AFHTTPRequestOperation *operation3 = [[AFHTTPRequestOperation alloc] initWithRequest:request3];
            //    [operation setUploadProgressBlock:block];
            [operation3 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"progress22 %lld of %lld",totalBytesWritten+imageDataSize+audioDataSize,totalDataSize);
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:taskID forKey:@"taskID"];
                [dict setObject:[NSString stringWithFormat:@"%f",(float)((double)(totalBytesWritten+imageDataSize+audioDataSize)/(double)totalDataSize)] forKey:@"taskProgress"];
                [dict setObject:@"taskAdd" forKey:@"taskType"];
                [dict setObject:@"sending" forKey:@"taskStatus"];
                [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
            }];
            [operation3 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"success thumb img upload:%@",[BaseQiNiuDownloadURL stringByAppendingString:thumbImgFileNameToUpload]);
                if (audioData) {
                    NSDictionary * parameters2 = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",audioFileNameToUpload,@"key", nil];
                    
                    NSMutableURLRequest *request2 = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters2 constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                        if (audioData) {
                            [formData appendPartWithFileData:audioData name:@"file" fileName:@"temp.wav" mimeType:@"wav"];
                            NSLog(@"audio data size:%lld",(long long)audioData.length);
                        }
                        
                    }];
                    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
                    //    [operation setUploadProgressBlock:block];
                    [operation2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        NSLog(@"progress22 %lld of %lld",totalBytesWritten+imageDataSize,totalDataSize);
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        [dict setObject:taskID forKey:@"taskID"];
                        [dict setObject:[NSString stringWithFormat:@"%f",(float)((double)(totalBytesWritten+imageDataSize)/(double)totalDataSize)] forKey:@"taskProgress"];
                        [dict setObject:@"taskAdd" forKey:@"taskType"];
                        [dict setObject:@"sending" forKey:@"taskStatus"];
                        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                    }];
                    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (contentDict) {
                            [contentDict setObject:@"0" forKey:@"model"];
                            [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:audioFileNameToUpload] forKey:@"audioUrl"];
                            [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload] forKey:@"photoUrl"];
                            [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:thumbImgFileNameToUpload] forKey:@"thumbUrl"];
                            
                            NSMutableDictionary * finalDict = [NetServer commonDict];
                            [finalDict setObject:@"petalk" forKey:@"command"];
                            [finalDict setObject:@"create" forKey:@"options"];
                            [finalDict setObject:contentDict forKey:@"petalkDTO"];
                            
                            [NetServer uploadShuoShuoWithContent:finalDict TaskID:taskID Success:^(id responseObject) {
                                if (success) {
                                    success(responseObject,nil);
                                }
                            } failure:^(NSError *error) {
                                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                                [dict setObject:taskID forKey:@"taskID"];
                                [dict setObject:@"0" forKey:@"taskProgress"];
                                [dict setObject:@"taskAdd" forKey:@"taskType"];
                                [dict setObject:@"failed" forKey:@"taskStatus"];
                                [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                                [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                                if (failure) {
                                    failure(error);
                                }
                            }];
                        }
                        
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        [dict setObject:taskID forKey:@"taskID"];
                        [dict setObject:@"0" forKey:@"taskProgress"];
                        [dict setObject:@"taskAdd" forKey:@"taskType"];
                        [dict setObject:@"failed" forKey:@"taskStatus"];
                        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                        [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                        if (failure) {
                            failure(error);
                        }
                        [NetServer getUploadToken];
                        
                    }];
                    [httpClient enqueueHTTPRequestOperation:operation2];
                    
                }else{
                    if (contentDict) {
                        [contentDict setObject:@"1" forKey:@"model"];
                        [contentDict setObject:[NSArray array] forKey:@"decorations"];
                        [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload] forKey:@"photoUrl"];
                        [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:thumbImgFileNameToUpload] forKey:@"thumbUrl"];
                        
                        NSMutableDictionary * finalDict = [NetServer commonDict];
                        [finalDict setObject:@"petalk" forKey:@"command"];
                        [finalDict setObject:@"create" forKey:@"options"];
                        [finalDict setObject:contentDict forKey:@"petalkDTO"];
                        
                        [NetServer uploadShuoShuoWithContent:finalDict TaskID:taskID Success:^(id responseObject) {
                            if (success) {
                                success(responseObject,nil);
                            }
                        } failure:^(NSError *error) {
                            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                            [dict setObject:taskID forKey:@"taskID"];
                            [dict setObject:@"0" forKey:@"taskProgress"];
                            [dict setObject:@"taskAdd" forKey:@"taskType"];
                            [dict setObject:@"failed" forKey:@"taskStatus"];
                            [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                            [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                            if (failure) {
                                failure(error);
                            }
                        }];
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:taskID forKey:@"taskID"];
                [dict setObject:@"0" forKey:@"taskProgress"];
                [dict setObject:@"taskAdd" forKey:@"taskType"];
                [dict setObject:@"failed" forKey:@"taskStatus"];
                [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"TaskReceived" object:dict];
                if (failure) {
                    failure(error);
                }
                [NetServer getUploadToken];
                
            }];
            [httpClient enqueueHTTPRequestOperation:operation3];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:taskID forKey:@"taskID"];
        [dict setObject:@"0" forKey:@"taskProgress"];
        [dict setObject:@"taskAdd" forKey:@"taskType"];
        [dict setObject:@"failed" forKey:@"taskStatus"];
        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
        [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
        if (failure) {
            failure(error);
        }
        [NetServer getUploadToken];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

+(void)uploadFailedShuoShuoWithImage:(UIImage *)uploadImage ThumImg:(UIImage *)thumbImg Audio:(NSData *)audioData ContentDict:(NSMutableDictionary *)contentDict Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(id responseObject, NSString * fileURL))success failure:(void (^)(NSError *error))failure
{
    
    SystemServer * us = [SystemServer sharedSystemServer];
    
    NSURL *url = [NSURL URLWithString:@"http://upload.qiniu.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    
    NSString * imgFileNameToUpload = [NSString stringWithFormat:@"img/content/%@/%@.jpg",pathTime,gen_uuid()];
    NSString * audioFileNameToUpload = [NSString stringWithFormat:@"audio/comment/%@/%@.wav",pathTime,gen_uuid()];
    NSString * thumbImgFileNameToUpload = [NSString stringWithFormat:@"img/content/%@/%@.jpg",pathTime,gen_uuid()];
    
    NSString * taskID = imgFileNameToUpload;
    
    NSData *imageData  = nil;
    if (uploadImage) {
        imageData = UIImageJPEGRepresentation(uploadImage, 1);
    }
    NSData *thumbImgData  = nil;
    if (thumbImg) {
        thumbImgData = UIImageJPEGRepresentation(thumbImg, 1);
    }
    
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    NSString * thumbImgPath = [NSString stringWithFormat:@"/%@.jpg",gen_uuid()];
    NSString * thumbImgPathN = [subdirectoryw stringByAppendingString:thumbImgPath];
    if ([thumbImgData writeToFile:thumbImgPathN atomically:YES]) {
        NSLog(@"thum img write success");
    }
    else{
        NSLog(@"thum imh write failed");
    }
    
    long long imageDataSize = (long long)imageData.length;
    long long audioDataSize = (long long)audioData.length;
    long long thumbImgDataSize = (long long)thumbImgData.length;
    long long totalDataSize = imageDataSize+audioDataSize+thumbImgDataSize;
    
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    [dicts setObject:taskID forKey:@"taskID"];
    [dicts setObject:[NSString stringWithFormat:@"%f",0.0f/(double)totalDataSize] forKey:@"taskProgress"];
    [dicts setObject:@"taskAdd" forKey:@"taskType"];
    [dicts setObject:@"sending" forKey:@"taskStatus"];
    [dicts setObject:thumbImgPath forKey:@"thumbImgPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dicts];
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",imgFileNameToUpload,@"key", nil];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
            NSLog(@"image data size:%lld",(long long)imageData.length);
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //    [operation setUploadProgressBlock:block];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"progress11 %lld of %lld",totalBytesWritten,totalDataSize);
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:taskID forKey:@"taskID"];
        [dict setObject:[NSString stringWithFormat:@"%f",(float)((double)totalBytesWritten/(double)totalDataSize)] forKey:@"taskProgress"];
        [dict setObject:@"taskAdd" forKey:@"taskType"];
        [dict setObject:@"sending" forKey:@"taskStatus"];
        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSDictionary * dict = [receiveStr JSONValue];
        
        NSLog(@"success image upload:%@",[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload]);
        //        success(dict,[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload]);
        
        if (thumbImgData) {
            NSDictionary * parameters3 = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",thumbImgFileNameToUpload,@"key", nil];
            
            NSMutableURLRequest *request3 = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters3 constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                if (thumbImgData) {
                    [formData appendPartWithFileData:thumbImgData name:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
                    NSLog(@" thumb image data size:%lld",(long long)thumbImgData.length);
                }
                
            }];
            AFHTTPRequestOperation *operation3 = [[AFHTTPRequestOperation alloc] initWithRequest:request3];
            //    [operation setUploadProgressBlock:block];
            [operation3 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"progress22 %lld of %lld",totalBytesWritten+imageDataSize+audioDataSize,totalDataSize);
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:taskID forKey:@"taskID"];
                [dict setObject:[NSString stringWithFormat:@"%f",(float)((double)(totalBytesWritten+imageDataSize+audioDataSize)/(double)totalDataSize)] forKey:@"taskProgress"];
                [dict setObject:@"taskAdd" forKey:@"taskType"];
                [dict setObject:@"sending" forKey:@"taskStatus"];
                [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
            }];
            [operation3 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"success thumb img upload:%@",[BaseQiNiuDownloadURL stringByAppendingString:thumbImgFileNameToUpload]);
                if (audioData) {
                    NSDictionary * parameters2 = [NSDictionary dictionaryWithObjectsAndKeys:us.uploadToken,@"token",audioFileNameToUpload,@"key", nil];
                    
                    NSMutableURLRequest *request2 = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:parameters2 constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                        if (audioData) {
                            [formData appendPartWithFileData:audioData name:@"file" fileName:@"temp.wav" mimeType:@"wav"];
                            NSLog(@"audio data size:%lld",(long long)audioData.length);
                        }
                        
                    }];
                    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
                    //    [operation setUploadProgressBlock:block];
                    [operation2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        NSLog(@"progress22 %lld of %lld",totalBytesWritten+imageDataSize,totalDataSize);
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        [dict setObject:taskID forKey:@"taskID"];
                        [dict setObject:[NSString stringWithFormat:@"%f",(float)((double)(totalBytesWritten+imageDataSize)/(double)totalDataSize)] forKey:@"taskProgress"];
                        [dict setObject:@"taskAdd" forKey:@"taskType"];
                        [dict setObject:@"sending" forKey:@"taskStatus"];
                        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                    }];
                    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (contentDict) {
                            [contentDict setObject:@"0" forKey:@"model"];
                            [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:audioFileNameToUpload] forKey:@"audioUrl"];
                            [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload] forKey:@"photoUrl"];
                            [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:thumbImgFileNameToUpload] forKey:@"thumbUrl"];
                            
                            NSMutableDictionary * finalDict = [NetServer commonDict];
                            [finalDict setObject:@"petalk" forKey:@"command"];
                            [finalDict setObject:@"create" forKey:@"options"];
                            [finalDict setObject:contentDict forKey:@"petalkDTO"];
                            
                            [NetServer uploadShuoShuoWithContent:finalDict TaskID:taskID Success:^(id responseObject) {
                                if (success) {
                                    success(responseObject,nil);
                                }
                            } failure:^(NSError *error) {
                                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                                [dict setObject:taskID forKey:@"taskID"];
                                [dict setObject:@"0" forKey:@"taskProgress"];
                                [dict setObject:@"taskAdd" forKey:@"taskType"];
                                [dict setObject:@"failed" forKey:@"taskStatus"];
                                [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                                [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                                if (failure) {
                                    failure(error);
                                }
                            }];
                        }
                        
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        [dict setObject:taskID forKey:@"taskID"];
                        [dict setObject:@"0" forKey:@"taskProgress"];
                        [dict setObject:@"taskAdd" forKey:@"taskType"];
                        [dict setObject:@"failed" forKey:@"taskStatus"];
                        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                        [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                        if (failure) {
                            failure(error);
                        }
                        [NetServer getUploadToken];
                        
                    }];
                    [httpClient enqueueHTTPRequestOperation:operation2];
                    
                }else{
                    if (contentDict) {
                        [contentDict setObject:@"1" forKey:@"model"];
                        [contentDict setObject:[NSArray array] forKey:@"decorations"];
                        [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:imgFileNameToUpload] forKey:@"photoUrl"];
                        [contentDict setObject:[BaseQiNiuDownloadURL stringByAppendingString:thumbImgFileNameToUpload] forKey:@"thumbUrl"];
                        
                        NSMutableDictionary * finalDict = [NetServer commonDict];
                        [finalDict setObject:@"petalk" forKey:@"command"];
                        [finalDict setObject:@"create" forKey:@"options"];
                        [finalDict setObject:contentDict forKey:@"petalkDTO"];
                        
                        [NetServer uploadShuoShuoWithContent:finalDict TaskID:taskID Success:^(id responseObject) {
                            if (success) {
                                success(responseObject,nil);
                            }
                        } failure:^(NSError *error) {
                            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                            [dict setObject:taskID forKey:@"taskID"];
                            [dict setObject:@"0" forKey:@"taskProgress"];
                            [dict setObject:@"taskAdd" forKey:@"taskType"];
                            [dict setObject:@"failed" forKey:@"taskStatus"];
                            [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                            [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
                            if (failure) {
                                failure(error);
                            }
                        }];
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:taskID forKey:@"taskID"];
                [dict setObject:@"0" forKey:@"taskProgress"];
                [dict setObject:@"taskAdd" forKey:@"taskType"];
                [dict setObject:@"failed" forKey:@"taskStatus"];
                [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
                [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"TaskReceived" object:dict];
                if (failure) {
                    failure(error);
                }
                [NetServer getUploadToken];
                
            }];
            [httpClient enqueueHTTPRequestOperation:operation3];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:taskID forKey:@"taskID"];
        [dict setObject:@"0" forKey:@"taskProgress"];
        [dict setObject:@"taskAdd" forKey:@"taskType"];
        [dict setObject:@"failed" forKey:@"taskStatus"];
        [dict setObject:thumbImgPath forKey:@"thumbImgPath"];
        [self saveFailedShuoShuoWithImageData:imageData thumbImgData:thumbImgData AudioData:audioData taskDict:dict ContentDict:contentDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
        if (failure) {
            failure(error);
        }
        [NetServer getUploadToken];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}


+(void)saveFailedShuoShuoWithImageData:(NSData *)imgData thumbImgData:(NSData *)thumbImgData AudioData:(NSData *)audioData taskDict:(NSDictionary *)taskDict ContentDict:(NSDictionary *)contentDict
{
    NSString * fileName = gen_uuid();
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    
    NSString * imgPath = [subdirectoryw stringByAppendingString:[NSString stringWithFormat:@"/%@img.jpg",fileName]];
    NSString * thumbImgPath = [subdirectoryw stringByAppendingString:[NSString stringWithFormat:@"/%@thumb.jpg",fileName]];
    NSString * audioPath = [subdirectoryw stringByAppendingString:[NSString stringWithFormat:@"/%@audio.caf",fileName]];
    if ([imgData writeToFile:imgPath atomically:YES]) {
        NSLog(@"write failed img success");
    }
    else
    {
        NSLog(@"write failed img failed");
    }
    if ([thumbImgData writeToFile:thumbImgPath atomically:YES]) {
        NSLog(@"write failed thumbimg success");
    }
    else
    {
        NSLog(@"write failed thumbimg failed");
    }
    if (audioData&&[audioData writeToFile:audioPath atomically:YES]) {
        NSLog(@"write failed audio success");
    }
    else
    {
        NSLog(@"write failed audio failed");
    }
    
    NSMutableDictionary * realContentDict = [NSMutableDictionary dictionaryWithDictionary:contentDict];
    [realContentDict setObject:[NSString stringWithFormat:@"/%@img.jpg",fileName] forKey:@"localImgPath"];
    [realContentDict setObject:[NSString stringWithFormat:@"/%@thumb.jpg",fileName] forKey:@"localThumbImgPath"];
    [realContentDict setObject:[NSString stringWithFormat:@"/%@audio.caf",fileName] forKey:@"localAudioPath"];
    
    NSDictionary * fff = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].currentPet.petID]];
    NSMutableDictionary * toSaveDict;
    if (fff) {
        toSaveDict = [NSMutableDictionary dictionaryWithDictionary:fff];
    }
    else
    {
        toSaveDict = [NSMutableDictionary dictionary];

    }
//    NSMutableDictionary *
    [toSaveDict setObject:realContentDict forKey:[taskDict objectForKey:@"taskID"]];
    [[NSUserDefaults standardUserDefaults] setObject:toSaveDict forKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].currentPet.petID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"saved dict:%@",toSaveDict);
    
    
}
+(void)uploadShuoShuoWithContent:(NSMutableDictionary *)contentDict TaskID:(NSString *)taskID Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [NetServer requestWithParameters:contentDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ShuoShuo Upload success!");
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:taskID forKey:@"taskID"];
        [dict setObject:@"taskRemove" forKey:@"taskType"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
        if (failure) {
            failure(error);
        }
        NSLog(@"ShuoShuo Upload failed with error:%@!",error);
    }];
}

+(void)downloadZipFileWithUrl:(NSString *)zipUrl ZipName:(NSString *)zipName Success:(void (^)(NSString * zipfileName))success
                      failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:zipUrl]];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *subdirectory = [documentsDirectory stringByAppendingPathComponent:@"Accessorys"];
        
        NSString *zipPath = [subdirectory stringByAppendingPathComponent:zipName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
            NSString *subdirectoryws = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Accessorys/%@",[zipName substringToIndex:(zipName.length-4)]]];
            BOOL isDirss = FALSE;
            BOOL isDirExistss = [[NSFileManager defaultManager] fileExistsAtPath:subdirectoryws isDirectory:&isDirss];
            
            
            if (!(isDirExistss && isDirss))
            {
                [TFileManager unZipFile:zipName];
            }
            if (success) {
                success(zipName);
            }
        }
        else if ([responseObject writeToFile:zipPath atomically:YES]) {
            [TFileManager unZipFile:zipName];
            if (success) {
                success(zipName);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
    [operation start];;
}

+(void)downloadAudioFileWithURL:(NSString *)downloadURL TheController:(UIViewController *)controller Success:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];;
}
+(void)downloadImageFileWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName Success:(void (^)(NSString * imagefileName))success
                        failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *subdirectory = [documentsDirectory stringByAppendingPathComponent:@"Accessorys"];
        
        NSString *path = [subdirectory stringByAppendingPathComponent:imageName];
        
        if ([responseObject writeToFile:path atomically:YES]) {
            if (success) {
                success(imageName);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}

+(void)downloadCommonImageFileWithUrl:(NSString *)imageUrl Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}

+(void)getAllMsgCountSuccess:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"UMC" forKey:@"options"];
    NSString * petId = [UserServe sharedUserServe].currentPet.petID?[UserServe sharedUserServe].currentPet.petID:@"";
    [mDict setObject:petId forKey:@"petId"];
    if ([petId isEqualToString:@""]) {
        return;
    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * allCount = [responseObject objectForKey:@"value"];
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCount%@",[UserServe sharedUserServe].currentPet.petID]];
        if (haveCount) {
            int cha = [allCount intValue]-[haveCount intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].currentPet.petID]];
            if (cha>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SectionmsgNotiReceived" object:self userInfo:nil];
//                success(operation,responseObject);
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].currentPet.petID]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:allCount forKey:[NSString stringWithFormat:@"haveCount%@",[UserServe sharedUserServe].currentPet.petID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)getUploadToken
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"fs" forKey:@"command"];
    [mDict setObject:@"uptoken" forKey:@"options"];
    [mDict setObject:QINIUDomain forKey:@"domain"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SystemServer * us = [SystemServer sharedSystemServer];
        us.uploadToken = [responseObject objectForKey:@"value"];
        //        us.layout = [[responseObject objectForKey:@"qiniuToken"] intValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get upload token failed with error:%@",error);
    }];
}
+(void)getUserInfoById:(NSString *)petId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"pet" forKey:@"command"];
    [mDict setObject:@"one" forKey:@"options"];
    [mDict setObject:petId forKey:@"petId"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID?[UserServe sharedUserServe].currentPet.petID:@"" forKey:@"currPetId"];
    
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
//        self.thePet.petID = [[responseObject objectForKey:@"value"] objectForKey:@"id"];
//        self.thePet.nickname = [[responseObject objectForKey:@"value"] objectForKey:@"nickName"];
//        self.thePet.headImgURL = [[responseObject objectForKey:@"value"] objectForKey:@"headPortrait"];
//        [DatabaseServe saveMsgPetInfo:self.thePet];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}


@end
