//
//  Stitcher.h
//  StitchMan
//
//  Created by he qiyun on 13-07-08.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matcher.h"
#import "UIImageConverter.h"
#import "math.h"

@interface Stitcher : NSObject

+(UIImage *)stitchImage:(UIImage *)firstImage
              withImage:(UIImage *)secondImage
  usingKeypointPairList:(KeypointPairList *)pairList;

/*+(double)getTheta:(KeypointPair *)p1
               p2:(KeypointPair *)p2
               p3:(KeypointPair *)p3;*/
+(double)getTheta:(KeypointPair *)p1
               p2:(KeypointPair *)p2;

+(UIImage*)mergeTheImage:(UIImage*)first withImage:(UIImage*)second;

+(UIImage *)rotateImage:(UIImage *)im
               rotation:(double)rotationAngel;

+(UIImage *)fillImage:(UIImage *)originalImage;

+(UIImage *)rotateUIImage:(UIImage *)originalImage
                 rotation:(double)rotationAngel
               referenceX:(int) x
               referenceY:(int) y
                     setX:(int) xx
                     setY:(int) yy
                setHeight:(int) newHeight
                 setWidth:(int) newWidth;

+(unsigned char*)expandRawData:(unsigned char*)rawData
                        height:(int) height
                         width:(int) width
                  expandLength:(int) expandLength;

+(unsigned char*)rotateRawData:(unsigned char *)rawData
                        height:(int) height
                         width:(int) width
                    referenceX:(int) x
                    referenceY:(int) y
                          setX:(int) xx
                          setY:(int) yy
                     setHeight:(int) newHeight
                      setWidth:(int) newWidth
                     rotatioon:(double) theta;

+(double)getAbsolute:(double)num;

+(UIImage *)changeScale:(UIImage *)im
                  scale:(double)scale;

+(UIImage *)combineTwoImages:(UIImage *)firstImage
                 secondImage:(UIImage *)secondImage;
@end
