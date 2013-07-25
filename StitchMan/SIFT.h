//
//  SIFT.h
//  StitchMan
//
//  Created by wjy on 13-7-6.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageMatrix.h"
#import "Pyramid.h"
#import "KeypointVector.h"

@interface SIFT : NSObject
{
    @public
    ImageMatrix *imageMatrix;
    Pyramid *pyramid;
    KeypointVector *keypointVector;
}

- (id)initWithImageMatrix:(ImageMatrix *)im;

- (void)buildPyramid;

- (void)detectKeypoints;

- (ImageMatrix *)originalImage;

- (ImageMatrix *)output __attribute((ns_returns_retained));

@end
