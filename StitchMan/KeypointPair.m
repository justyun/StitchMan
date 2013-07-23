//
//  KeypointPair.m
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "KeypointPair.h"

@implementation KeypointPair
-(id) initPair:(Keypoint *)p1
 secondKeypoint:(Keypoint *)p2
euclidianDistance:(int) distance{
    if (self = [super init]) {
        keypoint1 = p1;
        keypoint2 = p2;
        euclidianDistance = distance;
    }
    return self;
}
@end
