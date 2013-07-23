//
//  UIImageConverter.m
//  StitchMan
//
//  Created by he qiyun on 13-07-09.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "UIImageConverter.h"

@implementation UIImageConverter
+(UIImage *)data2UIImage:(unsigned char*)rawData
                  height:(int)height
                   width:(int)width{

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(rawData, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CFRelease(colorSpace);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    //release memory
    free(rawData);
    rawData=NULL;
    return resultImage;


}

+(unsigned char*)UIImage2Data:(UIImage *)im{

    CGImageRef imageRef = im.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    unsigned char *rawData = malloc(height * width * 4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    return rawData;

}
@end
