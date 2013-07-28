//
//  toAverage.h
//  StitchMan
//
//  Created by he qiyun on 13-07-26.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stitcher.h"

@interface toAverage : NSObject

+(double)getAverageTheta:(KeypointPairList *)pairList
           ofFirstNPairs:(int)num;

+(KeypointPair *)getAverageReferencePoint:(KeypointPairList *)pairList
                        ofFirstNPairs:(int)num;

+(double)getTheta:(KeypointPair *)p1
               p2:(KeypointPair *)p2;

@end
