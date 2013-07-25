//
//  ComplexMatrix.m
//  StitchMan
//
//  Created by wjy on 13-7-7.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ComplexMatrix.h"

@implementation ComplexMatrix

- (void)dealloc
{
    if(pNumbers!=NULL){
        free(pNumbers);
        pNumbers=NULL;
    }
}

- (id)initWithHeight:(int)h Width:(int)w
{
    if(self=[super init]){
        height=h;
        width=w;
        pNumbers=malloc(sizeof(complex)*height*width);
    }
    return self;
}

- (id)initWithImageMatrix:(ImageMatrix *)im
{
    if(self=[super init]){
        width=im->imageWidth;
        height=im->imageHeight;
        pNumbers=malloc(sizeof(complex)*height*width);
        for(int i=0;i<height;i++){
            for(int j=0;j<width;j++){
                pNumbers[i*width+j].real=im->pImage[i*width+j];
                pNumbers[i*width+j].imaginary=0;
            }
        }
    }
    return self;
}

- (complex)getValueAtHeight:(int)h Width:(int)w
{
    return pNumbers[h*width+w];
}

- (int)getHeight
{
    return height;
}

- (int)getWidth
{
    return width;
}

- (void)setValueAtHeight:(int)h Width:(int)w Value:(complex)value
{
    pNumbers[h*width+w].real=value.real;
    pNumbers[h*width+w].imaginary=value.imaginary;
}



- (void)print{
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            [Complex print:pNumbers[i*width+j]];
        }
    }
}

@end
