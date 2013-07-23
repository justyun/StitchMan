//
//  FFT.h
//  StitchMan
//
//  Created by wjy on 13-7-7.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageMatrix.h"

@interface FFT : NSObject

+ (ImageMatrix *)applyFFT2D:(ImageMatrix *)im;

+ (ImageMatrix *)applyIFFT2D:(ImageMatrix *)im;

@end
