//
//  main.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

//test
#import "Filter.h"
#import "ImageMatrix.h"
#import "Pyramid.h"
#import "MERGER.h"
#import "Stitcher.h"
#import "SIFT.h"
#import "Matcher.h"
#import "Match.h"

int main(int argc, char *argv[])
{
    //UIImage *im1 = [UIImage imageNamed:@"1.png"];
    //UIImage *im2 = [UIImage imageNamed:@"zebra2b.png"];
    UIImage *im1 = [UIImage imageNamed:@"orchard1.png"];
    UIImage *im2 = [UIImage imageNamed:@"orchard2.png"];

    ImageMatrix *m1 = [ImageConverter UIImage2ImageMatrixY:im1];
    ImageMatrix *m2 = [ImageConverter UIImage2ImageMatrixY:im2];
    SIFT *sift1=[[SIFT alloc] initWithImageMatrix:m1];
    SIFT *sift2=[[SIFT alloc] initWithImageMatrix:m2];

    KeypointPairList * matchResult = [Matcher getKeypointPairList:sift1->keypointVector secondKeypointVector:sift2->keypointVector];
    
    printf("%d\n",[matchResult->pairList count]);

    UIImage * im3 = [Stitcher stitchImage:im1
                                withImage:im2
                    usingKeypointPairList:matchResult];
    
    UIImage * redLinedImage = [drawRedLines drawRedLine:im1
                                            secondImage:im2
                                               pairList:matchResult
                                          numberOfLines:2];

    [UIImagePNGRepresentation(im3) writeToFile:@"/Users/heqiyun/Desktop/my.png" atomically:YES];
    [UIImagePNGRepresentation(redLinedImage) writeToFile:@"/Users/heqiyun/Desktop/redLinedImage.png" atomically:YES];

    
    @autoreleasepool {
        
        
            UIImage *uiimage1=[UIImage imageWithContentsOfFile:@"/Users/heqiyun/Downloads/1.png"];
            UIImage *uiimage2=[UIImage imageWithContentsOfFile:@"/Users/heqiyun/Downloads/zebra2r.png"];
            ImageMatrix *im1=[ImageConverter UIImage2ImageMatrixY:uiimage1];
            ImageMatrix *im2=[ImageConverter UIImage2ImageMatrixY:uiimage2];
            
            SIFT *sift1=[[SIFT alloc] initWithImageMatrix:im1];
            SIFT *sift2=[[SIFT alloc] initWithImageMatrix:im2];
            
            Match *match=[[Match alloc] initWithSIFT1:sift1 SIFT2:sift2];
            UIImage *imout=[match output];
            NSData *data=UIImagePNGRepresentation(imout);
            NSString *str=[[NSString alloc] initWithFormat:@"/Users/heqiyun/Desktop/testMatch.png"];
            [[NSFileManager defaultManager] createFileAtPath:str contents:data attributes:nil];
            
            
            
        
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
