//
//  GaussianElimination.h
//  StitchMan
//
//  Created by wjy on 13-7-27.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GaussianElimination : NSObject

+ (BOOL)solveWithVariate:(int)num Matrix:(double *)mat;

@end
