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

int main(int argc, char *argv[])
{
    UIImage *im1 = [UIImage imageNamed:@"1.png"];
    UIImage *im2 = [UIImage imageNamed:@"2.png"];
    ImageMatrix *m1 = [ImageConverter UIImage2ImageMatrixY:im1];
    ImageMatrix *m2 = [ImageConverter UIImage2ImageMatrixY:im2];
    SIFT *sift1=[[SIFT alloc] initWithImageMatrix:m1];
    SIFT *sift2=[[SIFT alloc] initWithImageMatrix:m2];

    KeypointPairList * matchResult = [Matcher getKeypointPairList:sift1->keypointVector secondKeypointVector:sift2->keypointVector];
    
    printf("%d\n",[matchResult->pairList count]);
    KeypointPair *kp=[matchResult->pairList objectAtIndex:0];
    [kp->keypoint1 print];
    [kp->keypoint2 print];
    kp=[matchResult->pairList objectAtIndex:1];
    [kp->keypoint1 print];
    [kp->keypoint2 print];
    kp=[matchResult->pairList objectAtIndex:2];
    [kp->keypoint1 print];
    [kp->keypoint2 print];
    kp=[matchResult->pairList objectAtIndex:3];
    [kp->keypoint1 print];
    [kp->keypoint2 print];
    kp=[matchResult->pairList objectAtIndex:4];
    [kp->keypoint1 print];
    [kp->keypoint2 print];
    kp=[matchResult->pairList objectAtIndex:5];
    [kp->keypoint1 print];
    [kp->keypoint2 print];
    

   UIImage * im3 = [Stitcher stitchImage:im1
                                withImage:im2
                    usingKeypointPairList:matchResult];
    
    //UIImage *im3 = [Stitcher mergeTheImage:im1 withImage:im2];
    //UIImage *im3 = [Stitcher fillImage:im2];
   /* UIImage *im3 = [Stitcher rotateUIImage:im2
                                  rotation:1.57
                                referenceX:38
                                referenceY:32
                                      setX:100
                                      setY:100
                                 setHeight:200
                                  setWidth:200];*/
   // UIImage *im3 = [Stitcher changeScale:im1 scale:2.3];
    [UIImagePNGRepresentation(im3) writeToFile:@"/Users/heqiyun/Desktop/my.png" atomically:YES];
    
    @autoreleasepool {
        /*
         double input[120]={  12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,
         12,34,56,78,90,11,12,34,56,78,90,11,};
         
         double filter[9]={ -1.0/4,0,1.0/4,
         -2.0/4,0,2.0/4,
         -1.0/4,0,1.0/4};
         
         id inputMatrix=[[ImageMatrix alloc] initWithArray:input Height:10 Width:12];
         id filterMatrix=[[ImageMatrix alloc] initWithArray:filter Height:3 Width:3];
         
         //[inputMatrix print];
         //[filterMatrix print];
         
         ImageMatrix *output;
         
         //while(1)
         //output=[Convolution conv:inputMatrix filter:filterMatrix];
         output=[Convolution convWithGaussian:inputMatrix sigma:2 filterSize:13];
         
         [output print];
         
         output=nil;
         inputMatrix=nil;
         filterMatrix=nil;
         */
        
        /*
         double input[65536];
         for(int i=0;i<256;i++)
         for(int j=0;j<256;j++)
         input[i*256+j]=(i+j)%256;
         Pyramid *test=[[Pyramid alloc] initWithImageMatrix:[[ImageMatrix alloc]
         initWithArray:input
         Height:256
         Width:256]];
         */
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
