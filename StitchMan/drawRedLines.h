//
//  drawRedLines.h
//  StitchMan
//
//  Created by he qiyun on 13-07-24.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stitcher.h"
#import "ImageConverter.h"
#import "ImageMatrix.h"

@interface drawRedLines : NSObject

+(UIImage *)drawRedLine:(UIImage *)im1
            secondImage:(UIImage *)im2
               pairList:(KeypointPairList *)pairList
          numberOfLines:(int)num;



@end
