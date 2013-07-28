//
//  Keypoint.h
//  StitchMan
//
//  Created by wjy on 13-7-5.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keypoint : NSObject
{
    @public
    double x;
    double y;
    
    double x_oct;
    double y_oct;
    
    int octave_num;
    int interval_num;
    double sub_interval_num;
    
    double descriptor[4][4][8];
    
    double theta;
    
}

- (id)initWithX:(double)x Y:(double)y X_OCT:(double)x_oct Y_OCT:(double)y_oct
         Octave:(int)octave_num Interval:(int)interval_num Subinterval:(double)sub_interval_num;

- (id)initWithKeypoint:(Keypoint *)keypoint;

- (void)print;

@end
