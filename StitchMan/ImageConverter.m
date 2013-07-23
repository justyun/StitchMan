//
//  ImageConverter.m
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ImageConverter.h"

@implementation ImageConverter

+ (ImageMatrix *)UIImage2ImageMatrixY:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    float *grayscale = malloc(sizeof(float) * height * width);
    
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
    
    
    int count=0;
    for(int i=0;i<height*width*4;i++){
        int x = rawData[i];
        if (x!=0) {
            count++;
        }
        //    printf("%d\n",x);
    }
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        grayscale[i] = (0.299 * (int)rawData[j] + 0.587 * (int)rawData[j+1] + 0.114 * (int)rawData[j+2]);
        
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:grayscale
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(grayscale);
    grayscale=NULL;
    
    return output;
}

+ (ImageMatrix *)UIImage2ImageMatrixU:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    float *componentU = malloc(sizeof(float) * height * width);
    
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
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        componentU[i] = -0.09991 * (int)rawData[j] -  0.33609* (int)rawData[j+1] + 0.436 * (int)rawData[j+2];
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:componentU
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(componentU);
    componentU=NULL;
    
    return output;
}

+ (ImageMatrix *)UIImage2ImageMatrixV:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    float *componentV = malloc(sizeof(float) * height * width);
    
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
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        componentV[i] = 0.615 * (int)rawData[j] - 0.58861 * (int)rawData[j+1] - 0.05639 * (int)rawData[j+2];
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:componentV
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(componentV);
    componentV=NULL;
    
    
    return output;
}

+ (ImageMatrix *)UIImage2ImageMatrixAlpha:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    float *componentAlpha = malloc(sizeof(float) * height * width);
    
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
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        componentAlpha[i] = (int)rawData[j+3];
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:componentAlpha
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(componentAlpha);
    componentAlpha=NULL;
    
    
    return output;
}

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im __attribute((ns_returns_retained))
{
    int i,j;
    int height = im->imageHeight;
    int width = im->imageWidth;
    NSUInteger totalPixel = width * height;
    float *grayscale = malloc(sizeof(float) * height * width);
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            grayscale[i * width + j] = im->pImage[i*im->imageWidth+j];
            
        }
    }
    unsigned char *rawData = malloc(height * width * 4);
    for (int i=0; i<totalPixel; i++) {
        int j = 4*i;
        rawData[j] = (unsigned char)grayscale[i];
        rawData[j+1] = (unsigned char)grayscale[i];
        rawData[j+2] = (unsigned char)grayscale[i];
        rawData[j+3] = (unsigned char)255;
    }
    
    // build uiimage
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
    free(grayscale);
    grayscale=NULL;
    
    return resultImage;
}


+ (UIImage *) ImageMatrix2UIImage:(ImageMatrix *)im
                       componentU:(ImageMatrix *)U
                       componentV:(ImageMatrix *)V
                   componentAlpha:(ImageMatrix *)Alpha
{
    int i,j;
    int height = im->imageHeight;
    int width = im->imageWidth;
    NSUInteger totalPixel = width * height;
    float *grayscale = malloc(sizeof(float) * height * width);
    float *componentU = malloc(sizeof(float) * height * width);
    float *componentV = malloc(sizeof(float) * height * width);
    float *componentAlpha = malloc(sizeof(float) * height * width);
    
    //grayscale = im.returnGrayScale;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            grayscale[i * width + j] = im->pImage[i*im->imageWidth+j];
            
        }
    }
    
    
    //componentU = im.returnComponentU;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            componentU[i * width + j] = U->pImage[i*U->imageWidth+j];
        }
    }
    //componentV = im.returnComponentV;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            componentV[i * width + j] = V->pImage[i*V->imageWidth+j];
        }
    }
    //componentAlpha = im.returnComponentAlpha;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            componentAlpha[i * width + j] = Alpha->pImage[i*Alpha->imageWidth+j];
            
        }
    }
    unsigned char *rawData = malloc(height * width * 4);
    for (int i=0; i<totalPixel; i++) {
        int j = 4*i;
        rawData[j] = (unsigned char)(grayscale[i] + 1.28033*componentV[i]);
        rawData[j+1] = (unsigned char)(grayscale[i] - 0.21482*componentU[i] - 0.38059*componentV[i]);
        rawData[j+2] = (unsigned char)(grayscale[i] + 2.12798*componentU[i]);
        rawData[j+3] = (unsigned char)componentAlpha[i];
    }
    
    // build uiimage
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
    free(grayscale);
    grayscale=NULL;
    free(componentU);
    componentU=NULL;
    free(componentV);
    componentV=NULL;
    free(componentAlpha);
    componentAlpha=NULL;
    
    return resultImage;
}

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im
                       withMark:(ImageMatrix *)mark
__attribute((ns_returns_retained))
{
    int i,j,threshold=180;
    int height = im->imageHeight;
    int width = im->imageWidth;
    NSUInteger totalPixel = width * height;
    float *grayscale = malloc(sizeof(float) * height * width);
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            grayscale[i * width + j] = im->pImage[i*im->imageWidth+j];
            
        }
    }
    unsigned char *rawData = malloc(height * width * 4);
    for (int i=0; i<totalPixel; i++) {
        int j = 4*i;
        if((int)mark->pImage[i]>threshold){
            rawData[j]=255;
            rawData[j+1]=0;
            rawData[j+2]=0;
            rawData[j+3]=200;
        }
        else{
        rawData[j] = (unsigned char)grayscale[i];
        rawData[j+1] = (unsigned char)grayscale[i];
        rawData[j+2] = (unsigned char)grayscale[i];
        rawData[j+3] = (unsigned char)255;
        }
    }
    
    // build uiimage
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
    free(grayscale);
    grayscale=NULL;
    
    return resultImage;



}



@end

