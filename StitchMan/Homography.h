//
//  Homography.h
//  StitchMan
//
//  Created by wjy on 13-7-27.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homography : NSObject

+ (double *)findHomography2DWithX1:(double)x1 Y1:(double)y1 X11:(double)x11 Y11:(double)y11
                                X2:(double)x2 Y2:(double)y2 X22:(double)x22 Y22:(double)y22
                                X3:(double)x3 Y3:(double)y3 X33:(double)x33 Y33:(double)y33
                                X4:(double)x4 Y4:(double)y4 X44:(double)x44 Y44:(double)y44;



@end
