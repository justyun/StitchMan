//
//  ImageConverter.h
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageMatrix.h"

@interface ImageConverter : NSObject

+ (ImageMatrix *)UIImage2ImageMatrixY:(UIImage *)uiimage __attribute((ns_returns_retained));

+ (ImageMatrix *)UIImage2ImageMatrixU:(UIImage *)uiimage __attribute((ns_returns_retained));

+ (ImageMatrix *)UIImage2ImageMatrixV:(UIImage *)uiimage __attribute((ns_returns_retained));

+ (ImageMatrix *)UIImage2ImageMatrixAlpha:(UIImage *)uiimage __attribute((ns_returns_retained));

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im __attribute((ns_returns_retained));

+ (UIImage *) ImageMatrix2UIImage:(ImageMatrix *)im
                       componentU:(ImageMatrix *)U
                       componentV:(ImageMatrix *)V
                   componentAlpha:(ImageMatrix *)Alpha;

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im withMark:(ImageMatrix *)mark __attribute((ns_returns_retained));

@end
