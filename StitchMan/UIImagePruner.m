//
//  UIImagePruner.m
//  StitchMan
//
//  Created by he qiyun on 13-07-24.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "UIImagePruner.h"

@implementation UIImagePruner

+(UIImage *)pruneImage:(UIImage *)im{
    int height = im.size.height;
    int width = im.size.width;
    int newHeight, newWidth;
    int pixelNum, alphaNum;
    int minStartX = width, minStartY = height, maxEndingX = 0, maxEndingY = 0;
    unsigned char *imRawData = [UIImageConverter UIImage2Data:im];
    UIImage *resultImage;
    
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            pixelNum = width * i + j;
            alphaNum = 4 * pixelNum + 3;
            if (imRawData[alphaNum]!=0) {
                minStartX = (j < minStartX)?j:minStartX;
                minStartY = (i < minStartY)?i:minStartY;
                maxEndingX = (j > maxEndingX)?j:maxEndingX;
                maxEndingY = (i > maxEndingY)?i:maxEndingY;
            }
        }
    }

    newHeight = maxEndingY - minStartY + 1;
    newWidth = maxEndingX - minStartX + 1;
    
    printf("height: %d \nwidth: %d \nminStartX = %d, minStartY = %d, maxEndingX = %d, maxEndingY = %d \nnewHeight = %d, newWidth = %d\n",height,width,minStartX,minStartY,maxEndingX,maxEndingY,newHeight,newWidth);
    
    unsigned char *newData = malloc(newHeight * newWidth * 4 * sizeof(unsigned char));
    for (int i = 0; i < newHeight; i++) {
        for (int j = 0; j < newWidth; j++) {
            newData[4 * (i * newWidth + j)] = imRawData[4 * ((i + minStartX) * width + (j + minStartY))];
            newData[4 * (i * newWidth + j) + 1] = imRawData[4 * ((i + minStartX) * width + (j + minStartY)) + 1];
            newData[4 * (i * newWidth + j) + 2] = imRawData[4 * ((i + minStartX) * width + (j + minStartY)) + 2];
            newData[4 * (i * newWidth + j) + 3] = imRawData[4 * ((i + minStartX) * width + (j + minStartY)) + 3];
        }
    }

    resultImage = [UIImageConverter data2UIImage:newData
                                          height:newHeight
                                           width:newWidth];
    return resultImage;
}




@end
