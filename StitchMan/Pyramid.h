//
//  Pyramid.h
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Filter.h"
#import "ImageMatrix.h"
#import "ImageConverter.h"

@interface Pyramid : NSObject
{
@public
    int octaveNum;
    int intervalNum;
    float sigma[20];
    
    int originalHeight;
    int originalWidth;
    ImageMatrix *originalImage;
    
    ImageMatrix *horizontalGaussianFilter[20];
    ImageMatrix *verticalGaussianFilter[20];
    
    NSMutableArray *gaussianPyramid;
    NSMutableArray *differenceOfGaussianPyramid;
}

- (id)initWithImageMatrix:(ImageMatrix *)originalImage;

- (ImageMatrix *)getGaussianMatrixAtOctave:(int)octave_num Interval:(int)interval_num;

- (ImageMatrix *)getDifferenceOfGaussianMatrixAtOctave:(int)octave_num Interval:(int)interval_num;

- (int)getOctaveNum;

- (int)getIntervalNum;

- (void)output;

@end
