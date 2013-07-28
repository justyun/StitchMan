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
        
        [pyramid output];
        
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
    int x,y;
    for(int i=0;i<length;i++){
        Keypoint *p=[keypointVector->keypoints objectAtIndex:i];
        x=round(p->x);
        y=round(p->y);
        
        output->pImage[y*width+x]=255;
        output->pImage[(y+1)*width+x+1]=255;
        output->pImage[(y+1)*width+x-1]=255;
        output->pImage[(y-1)*width+x+1]=255;
        output->pImage[(y-1)*width+x-1]=255;
        
        if(x<width-2 && y<height-2)
            output->pImage[(y+2)*width+x+2]=255;
        if(x>1 && y<height-2)
            output->pImage[(y+2)*width+x-2]=255;
        if(x<width-2 && y>1)
            output->pImage[(y-2)*width+x+2]=255;
        if(x>1 && y>1)
            output->pImage[(y-2)*width+x-2]=255;
    }
    return output;
}

@end
