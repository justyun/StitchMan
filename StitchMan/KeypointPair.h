//
//  KeypointPair.h
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keypoint.h"

@interface KeypointPair : NSObject
{
    @public
    Keypoint * keypoint1;
    Keypoint * keypoint2;
    int euclidianDistance;
}
-(id) initPair:(Keypoint *)p1
 secondKeypoint:(Keypoint *)p2
euclidianDistance:(int) distance;
@end
