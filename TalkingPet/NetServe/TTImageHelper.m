//
//  TTImageHelper.m
//  TalkingPet
//
//  Created by Tolecen on 14-8-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TTImageHelper.h"
#import <Accelerate/Accelerate.h>

@implementation TTImageHelper
//图片压缩 两个方法组合
+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY
{
    
    UIImage * bigImage = theImage;
    
    float actualHeight = bigImage.size.height;
    float actualWidth = bigImage.size.width;
    
    float imgRatio = actualWidth / actualHeight;
    if(actualWidth > sizeX || actualHeight > sizeY)
    {
        float maxRatio = sizeX / sizeY;
        
        if(imgRatio < maxRatio){
            imgRatio = sizeX / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = sizeX;
        } else {
            imgRatio = sizeY / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = sizeY;
            
        }
        
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [bigImage drawInRect:rect];  // scales image to rect
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *) image: (UIImage *) image centerInSize: (CGSize) viewsize
{
    CGSize size = image.size;
    
    UIGraphicsBeginImageContext(viewsize);
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}
//图片压缩 设置最宽，按比例压缩
+(UIImage*)compressImage:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY
{
    
    UIImage * bigImage = theImage;
    float actualHeight = bigImage.size.height;
    float actualWidth = bigImage.size.width;
    float imgRatio = actualWidth / actualHeight;
    if (actualWidth > sizeX) {
        imgRatio = sizeX / actualWidth;
        actualHeight = imgRatio * actualHeight;
        actualWidth = sizeX;
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [bigImage drawInRect:rect];  // scales image to rect
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%f==%f",theImage.size.width,theImage.size.height);
    return theImage;
}

+(UIImage*)cutImage:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY
{
    
    UIImage * bigImage = theImage;
    float originx = 0;
    float originy = 0;
    float theW = bigImage.size.width;
    float theH = bigImage.size.height;
    CGRect rect = CGRectMake(0, 0, 0, 0);
    if (theW>theH) {
        originx = (theW-theH)/2;
        rect = CGRectMake(originx, originy, theH, theH);
    }
    else
    {
        originy = (theH-theW)/2;
        rect = CGRectMake(originx, originy, theW, theW);
    }
    //	CGRect rect = CGRectMake(originx, originy, sizeX, sizeY);
    //	UIGraphicsBeginImageContext(rect.size);
    //	[bigImage drawInRect:rect];  // scales image to rect
    //	theImage = UIGraphicsGetImageFromCurrentImageContext();
    //	UIGraphicsEndImageContext();
    //    NSLog(@"%f==%f",theImage.size.width,theImage.size.height);
    
    UIImage *croppedImage = [bigImage croppedImage:rect];
    
    return croppedImage;
}
+(UIImage *)blurImage:(UIImage *)image
{
    float blur = 0.9;
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(img));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
