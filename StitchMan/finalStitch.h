//
//  finalStitch.h
//  StitchMan
//
//  Created by he qiyun on 13-07-25.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Filter.h"
#import "ImageMatrix.h"
#import "Pyramid.h"
#import "Stitcher.h"
#import "SIFT.h"
#import "Matcher.h"
#import "Match.h"

@interface finalStitch : NSObject

+(UIImage *)finalStitch:(UIImage *)im1
            secondImage:(UIImage *)im2;

@end
