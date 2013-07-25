//
//  drawRedLines.m
//  StitchMan
//
//  Created by he qiyun on 13-07-24.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "drawRedLines.h"

@implementation drawRedLines

+(UIImage *)drawRedLine:(UIImage *)im1
            secondImage:(UIImage *)im2
               pairList:(KeypointPairList *)pairList
          numberOfLines:(int)num{
    
    
    int i,j;
    int height1 = im1.size.height;
    int width1 = im1.size.width;
    int height2 = im2.size.height;
    int width2 = im2.size.width;
    int space=50;
    int height = (height1>=height2)?height1:height2;
    int width = width1 + width2 +space;
    unsigned char *rawData1 = [UIImageConverter UIImage2Data:im1];
    unsigned char *rawData2 = [UIImageConverter UIImage2Data:im2];
    unsigned char *newData = malloc(height * width * 4 *sizeof(unsigned char));
    
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            if(i<height1 && j<width1){
                newData[4*(i*width+j)]=rawData1[4*(i*width1+j)];
                newData[4*(i*width+j)+1]=rawData1[4*(i*width1+j)+1];
                newData[4*(i*width+j)+2]=rawData1[4*(i*width1+j)+2];
                newData[4*(i*width+j)+3]=rawData1[4*(i*width1+j)+3];
            }
            else if(i<height2 && j>=width-width2){
                newData[4*(i*width+j)]=rawData2[4*(i*width2+j-width1-space)];
                newData[4*(i*width+j)+1]=rawData2[4*(i*width2+j-width1-space)+1];
                newData[4*(i*width+j)+2]=rawData2[4*(i*width2+j-width1-space)+2];
                newData[4*(i*width+j)+3]=rawData2[4*(i*width2+j-width1-space)+3];
            }
            else
                newData[4*(i*width+j)+3]=255;
        }
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(newData, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    //CGContextSetLineWidth(bitmapContext,5);
    CGContextSetStrokeColorWithColor(bitmapContext, [[UIColor redColor] CGColor]);
    
    //draw matches
    for(int i=0;i<num;i++){
            Keypoint *kp1=((KeypointPair *)[pairList->pairList objectAtIndex:i])->keypoint1;
            Keypoint *kp2=((KeypointPair *)[pairList->pairList objectAtIndex:i])->keypoint2;
            
            CGFloat x1=kp1->x;
            CGFloat y1=height-1-kp1->y;
            CGFloat x2=kp2->x+width1+space;
            CGFloat y2=height-1-kp2->y;
            CGContextMoveToPoint(bitmapContext,x1,y1);
            CGContextAddLineToPoint(bitmapContext,x2,y2);
        
    }
    
    CGContextStrokePath(bitmapContext);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage * resultImage = [UIImage imageWithCGImage:cgImage];
    
    
    CFRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(cgImage);
    
    //release memory
    free(newData);
    newData=NULL;

    
    return resultImage;
}
@end
