//
//  ImageMatrix.m
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ImageMatrix.h"

@implementation ImageMatrix


- (id)initWithUIImage:(UIImage *)uiimage
{
    if(self=[super init]){
        
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithArray:(float *)array Height:(int)height Width:(int)width
{
    if(self=[super init]){
        imageWidth=width;
        imageHeight=height;
        pImage=malloc(sizeof(float)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]=array[i*imageWidth+j];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithImageMatrix:(ImageMatrix *)im
{
    if(self=[super init]){
        imageWidth=[im getWidth];
        imageHeight=[im getHeight];
        pImage=malloc(sizeof(float)*imageHeight*imageWidth);
        //bzero(pImage,sizeof(float)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]=im->pImage[i*imageWidth+j];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithImageMatrix:(ImageMatrix *)im Subtract:(ImageMatrix *)im2
{
    if(self=[super init]){
        imageWidth=[im getWidth];
        imageHeight=[im getHeight];
        pImage=malloc(sizeof(float)*imageHeight*imageWidth);
        //bzero(pImage,sizeof(float)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]
                =im->pImage[i*imageWidth+j]-im2->pImage[i*imageWidth+j];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithImageMatrixByDownsampling:(ImageMatrix *)im Factor:(int)factor
{
    if(self=[super init]){
        int originalWidth=im->imageWidth;
        imageWidth=[im getWidth]/factor;
        imageHeight=[im getHeight]/factor;
        pImage=malloc(sizeof(float)*imageHeight*imageWidth);
        //bzero(pImage,sizeof(float)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]=im->pImage[((i+1)*factor-1)*originalWidth+((j+1)*factor-1)];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithHeight:(int)height Width:(int)width
{
    if(self=[super init]){
        imageWidth=width;
        imageHeight=height;
        pImage=malloc(sizeof(float)*imageHeight*imageWidth);
        //bzero(pImage,sizeof(float)*imageHeight*imageWidth);
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithHeight:(int)height Width:(int)width Value:(float)value
{
    if(self=[super init]){
        imageWidth=width;
        imageHeight=height;
        pImage=malloc(sizeof(float)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++){
            for(int j=0;j<imageWidth;j++){
                pImage[i*imageWidth+j]=value;
            }
        }
        //NSLog(@"init");
    }
    return self;
}

- (void)dealloc
{
    if(pImage!=NULL){
        free(pImage);
        pImage=NULL;
        //NSLog(@"dealloc");
    }
}


- (void)expandWithValue:(float)value
                    Top:(int)top Bottom:(int)bottom
                   Left:(int)left Right:(int)right
{
    imageHeight=imageHeight+top+bottom;
    imageWidth=imageWidth+left+right;
    
    float *old=realloc(pImage,sizeof(pImage));
    
    pImage=malloc(sizeof(float)*imageWidth*imageHeight);
    
    for(int i=0;i<imageHeight;i++){
        for(int j=0;j<imageWidth;j++){
            if(i<top || imageHeight-i-1<bottom || j<left || imageWidth-j-1<right){
                pImage[i*imageWidth+j]=value;
            }
            else{
                pImage[i*imageWidth+j]=old[(i-top)*(imageWidth-left-right)+j-left];
            }
        }
    }
    free(old);
}

/*
- (float)getValueAtHeight:(int)height Width:(int)width
{
    return pImage[height*imageWidth+width];
}
*/
 
- (int)getHeight
{
    return imageHeight;
}

-(int)getWidth
{
    return imageWidth;
}

/*
- (void)setValueAtHeight:(int)height Width:(int)width Value:(float)value
{
    pImage[height*imageWidth+width]=value;
}
*/


- (void)print
{
    for(int i=0;i<imageHeight;i++){
        for(int j=0;j<imageWidth;j++){
            printf("%-7.2f ",pImage[i*imageWidth+j]);
        }
        printf("\n");
    }
    printf("\n");
}

@end
