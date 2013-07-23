//
//  MERGER.h
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matcher.h"

@interface MERGER : NSObject

+(UIImage *)mergeImage:(UIImage *)firstImage
           secondImage:(UIImage *)secondImage
      KeypointPairList:(KeypointPairList *)pairList;

+(double)getTheta:(KeypointPair *)p1
               p2:(KeypointPair *)p2
               p3:(KeypointPair *)p3;

+(UIImage*)mergeTheImage:(UIImage*)first withImage:(UIImage*)second;

+(UIImage *)rotateImage:(UIImage *)im;
+(UIImageView *)rotateImageView:(UIImage *)im;


@end
