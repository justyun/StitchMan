//
//  Derivative.h
//  StitchMan
//
//  Created by wjy on 13-7-8.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageMatrix.h"
#import "Pyramid.h"

@interface Derivative : NSObject

+ (double *)deriv3D:(Pyramid *)pyramid Octave:(int)octave_num Interval:(int)interval_num
                       X:(int)x Y:(int)y;

+ (double *)hessian3D:(Pyramid *)pyramid Octave:(int)octave_num Interval:(int)interval_num
                   X:(int)x Y:(int)y;

@end
