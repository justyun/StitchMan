//
//  Matcher.h
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeypointPair.h"
#import "KeypointPairList.h"
#import "ImageMatrix.h"
#import "KeypointVector.h"
#import "Keypoint.h"

@interface Matcher : NSObject

+(KeypointPairList *)getKeypointPairList:(KeypointVector *)keypointVector1
                    secondKeypointVector:(KeypointVector *)keypointVector2
__attribute((ns_returns_retained));

+(double)getEuclidianDistance:(Keypoint *)p1
                    keypoint2:(Keypoint *)p2;

+(double)getSquaredEuclidianDistance:(Keypoint *)p1
                           keypoint2:(Keypoint *)p2;

@end
