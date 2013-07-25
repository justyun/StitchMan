//
//  SIFT.m
//  StitchMan
//
//  Created by wjy on 13-7-6.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "SIFT.h"

@implementation SIFT

- (id)initWithImageMatrix:(ImageMatrix *)im
{
    if(self=[super init]){
        clock_t start,finish;
        
        imageMatrix=[[ImageMatrix alloc] initWithImageMatrix:im];
        
        start=clock();
        [self buildPyramid];
        finish=clock();
        printf("%f seconds used to build pyramid\n",(float)(finish-start)/1000000);
        
        //[pyramid output];
        
        start=clock();
        [self detectKeypoints];
        finish=clock();
        printf("%f seconds used to detect keypoints\n",(float)(finish-start)/1000000);
        
        //[keypointVector output];
    }
    return self;
}

- (void)buildPyramid
{
    pyramid=[[Pyramid alloc] initWithImageMatrix:imageMatrix];
}

- (void)detectKeypoints
{
    keypointVector=[[KeypointVector alloc] initWithPyramid:pyramid];
}


- (ImageMatrix *)originalImage
{
    return imageMatrix;
}

- (ImageMatrix *)output __attribute((ns_returns_retained))
{
    ImageMatrix *output=[[ImageMatrix alloc] initWithHeight:imageMatrix->imageHeight
                                                      Width:imageMatrix->imageWidth
                                                      Value:0];
    
    int width=imageMatrix->imageWidth;
    int height=imageMatrix->imageHeight;
    int length=keypointVector.getLength;
    for(int i=0;i<length;i++){
        Keypoint *p=[keypointVector->keypoints objectAtIndex:i];
        output->pImage[p->y*imageMatrix->imageWidth+p->x]=255;
        output->pImage[(p->y+1)*imageMatrix->imageWidth+p->x+1]=255;
        output->pImage[(p->y+1)*imageMatrix->imageWidth+p->x-1]=255;
        output->pImage[(p->y-1)*imageMatrix->imageWidth+p->x+1]=255;
        output->pImage[(p->y-1)*imageMatrix->imageWidth+p->x-1]=255;
        
        if(p->x<width-2 && p->y<height-2)
            output->pImage[(p->y+2)*imageMatrix->imageWidth+p->x+2]=255;
        if(p->x>1 && p->y<height-2)
            output->pImage[(p->y+2)*imageMatrix->imageWidth+p->x-2]=255;
        if(p->x<width-2 && p->y>1)
            output->pImage[(p->y-2)*imageMatrix->imageWidth+p->x+2]=255;
        if(p->x>1 && p->y>1)
            output->pImage[(p->y-2)*imageMatrix->imageWidth+p->x-2]=255;
    }
    return output;
}

@end
