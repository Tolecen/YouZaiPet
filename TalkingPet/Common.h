//
//  Common.h
//  WeShare
//
//  Created by Elliott on 13-5-7.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+(NSString *)getCurrentTime;
+(NSString *)noteContentCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)noteCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)DynamicCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)CurrentTime:(long)currentTime AndMessageTime:(long)messageTime;
+(NSDate *)getCurrentTimeFromString:(NSString *)datetime;
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime;
+(NSString *)getWeakDay:(NSDate *)datetime;
+(int)minusNowDate:(NSDate *)date;
+(NSString *)getmessageTime:(NSDate *)date;
+(UIImage *)imageFromText:(int)count image:(UIImage *)image;
+(NSString *)getDateStringWithTimestamp:(NSString*)tamp;
+ (NSString *)dateStringBetweenNewToTimestamp:(NSString*)tamp;
+(NSString *)getExDateStringWithTimestamp:(NSString*)tamp;
+(float)diffHeight:(UIViewController *)controller;
+(NSString *)calAgeWithBirthDate:(NSString *)birthdate;
+(BOOL)ifHaveGuided:(NSString *)key;
+(void)setGuided:(NSString *)key;

+(void)addCountForCart;
+(void)clearCartCount;

+(NSString *)filterHTML:(NSString *)html;
@end
