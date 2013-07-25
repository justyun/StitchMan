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
    int x;
    int y;
    
    int x_oct;
    int y_oct;
    
    int octave_num;
    int interval_num;
    double sub_interval_num;
    
    double descriptor[4][4][8];
    
    double theta;
    
}

- (id)initWithX:(int)x Y:(int)y X_OCT:(int)x_oct Y_OCT:(int)y_oct
         Octave:(int)octave_num Interval:(int)interval_num Subinterval:(double)sub_interval_num;

- (id)initWithKeypoint:(Keypoint *)keypoint;

- (void)print;

@end
