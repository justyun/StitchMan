//
//  StitcherUsingHomography.h
//  StitchMan
//
//  Created by he qiyun on 13-07-27.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matcher.h"
#import "UIImageConverter.h"
#import "math.h"
#import "UIImagePruner.h"
#import "drawRedLines.h"
#import "toAverage.h"
#import "GaussianElimination.h"
#import "Homography.h"
#import "coordinate.h"
#import "KeypointPair.h"
#import "Stitcher.h"

@interface StitcherUsingHomography : NSObject

+(UIImage *)stitching:(UIImage *)firstImage
             andImage:(UIImage *)secondImage
usingKeypointPairList:(KeypointPairList *)pairList;


+(double *)getHomographicMatrix:(UIImage *)firstImage
                       andImage:(UIImage *)secondImage
          usingKeypointPairList:(KeypointPairList *)pairList;


@end
