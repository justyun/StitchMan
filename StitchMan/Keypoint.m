//
//  Keypoint.m
//  StitchMan
//
//  Created by wjy on 13-7-5.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Keypoint.h"

@implementation Keypoint

- (id)initWithX:(double)x1 Y:(double)y1 X_OCT:(double)x_oct1 Y_OCT:(double)y_oct1
         Octave:(int)octave_num1 Interval:(int)interval_num1 Subinterval:(double)sub_interval_num1
{
    if(self=[super init]){
        x=x1;
        y=y1;
        x_oct=x_oct1;
        y_oct=y_oct1;
        octave_num=octave_num1;
        interval_num=interval_num1;
        sub_interval_num=sub_interval_num1;
    }
    return self;
}


- (id)initWithKeypoint:(Keypoint *)keypoint
{
    if(self=[super init]){
        x=keypoint->x;
        y=keypoint->y;
        x_oct=keypoint->x_oct;
        y_oct=keypoint->y_oct;
        octave_num=keypoint->octave_num;
        interval_num=keypoint->interval_num;
        sub_interval_num=keypoint->sub_interval_num;
        theta=keypoint->theta;
    }
    return self;
}

- (void)print
{
    printf("Keypoint at: %d %d\n",y,x);
}

@end
