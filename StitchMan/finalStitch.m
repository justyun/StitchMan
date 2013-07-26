//
//  finalStitch.m
//  StitchMan
//
//  Created by he qiyun on 13-07-25.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "finalStitch.h"

@implementation finalStitch


+(UIImage *)finalStitch:(UIImage *)im1
            secondImage:(UIImage *)im2{
    
    ImageMatrix *m1 = [ImageConverter UIImage2ImageMatrixY:im1];
    ImageMatrix *m2 = [ImageConverter UIImage2ImageMatrixY:im2];
    SIFT *sift1=[[SIFT alloc] initWithImageMatrix:m1];
    SIFT *sift2=[[SIFT alloc] initWithImageMatrix:m2];
    
    KeypointPairList * matchResult = [Matcher getKeypointPairList:sift1->keypointVector secondKeypointVector:sift2->keypointVector];
    
    printf("%d\n",[matchResult->pairList count]);
    
    UIImage * im3 = [Stitcher stitchImage:im1
                                withImage:im2
                    usingKeypointPairList:matchResult];
    
    im3 = [UIImagePruner pruneImage:im3];
    return im3;

}
@end
