//
//  Match.h
//  StitchMan
//
//  Created by wjy on 13-7-12.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SIFT.h"

@interface Match : NSObject
{
    ImageMatrix *imageMatrix1;
    ImageMatrix *imageMatrix2;
    
    KeypointVector *keypointVector1;
    KeypointVector *keypointVector2;
    
    int *match;
    int size;
    int match_count;
    
    UIImage *output;
}

- (id)initWithSIFT1:(SIFT *)s1 SIFT2:(SIFT *)s2;

- (UIImage *)output;

@end
