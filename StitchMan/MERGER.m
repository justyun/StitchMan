//
//  MERGER.m
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "MERGER.h"
#import <math.h>

@implementation MERGER
+(UIImage *)mergeImage:(UIImage *)firstImage
           secondImage:(UIImage *)secondImage
      KeypointPairList:(KeypointPairList *)pairList{
   
    int newWidth;
    int newHeight;
    double theta;
    newWidth = firstImage.size.width + 2 * secondImage.size.width;
    newHeight = firstImage.size.height + 2 * secondImage.size.height;
    NSMutableArray *list = pairList.getPairList;
    KeypointPair *p1 = [list objectAtIndex:0];
    KeypointPair *p2 = [list objectAtIndex:1];
    KeypointPair *p3 = [list objectAtIndex:2];
    theta = [MERGER getTheta:p1 p2:p2 p3:p3];
    CGSize newImageSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newImageSize);
    [firstImage drawInRect:CGRectMake(secondImage.size.width, secondImage.size.height, firstImage.size.width, firstImage.size.height)];
    
    
    return firstImage;
}

+(double)getTheta:(KeypointPair *)p1
               p2:(KeypointPair *)p2
               p3:(KeypointPair *)p3{
    int x11,x21,x31,x12,x22,x32,y11,y21,y31,y12,y22,y32;
    x11 = p1->keypoint1->x;
    x12 = p1->keypoint2->x;
    x21 = p2->keypoint1->x;
    x22 = p2->keypoint2->x;
    x31 = p3->keypoint1->x;
    x32 = p3->keypoint2->x;
    y11 = p1->keypoint1->y;
    y12 = p1->keypoint2->y;
    y21 = p2->keypoint1->y;
    y22 = p2->keypoint2->y;
    y31 = p3->keypoint1->y;
    y32 = p3->keypoint2->y;
    
    double degree1 = atan2(y12-y11,x11-x12);
    double degree2 = atan2(y22-y21,x21-x22);
    double theta = degree1 - degree2;
    return theta;
}

+ (UIImage*)mergeTheImage:(UIImage*)first withImage:(UIImage*)second
{
    // get size of the first image
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // build merged size
    CGSize mergedSize = CGSizeMake(firstWidth + 2*secondWidth, firstHeight + 2*secondHeight);
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    UIImage * rotatedImage = [MERGER rotateImage:second rotation:0.1];
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    //[second drawInRect:CGRectMake(firstWidth, 0, secondWidth, secondHeight)];
    [rotatedImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];

    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*+(UIImage *)rotateImage:(UIImage *)im
               rotation:(double)rotationAngel
{
    CGImageRef cgref= im.CGImage;
    CGSize imageSize = im.size;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(contextRef, rotationAngel);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0,0,imageSize.width, imageSize.height),cgref);
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}*/


+(UIImage *)rotateImage:(UIImage *)im
               rotation:(double)rotationAngel
{
    CGSize imageSize = im.size;
    imageSize.width *=1.1;
    imageSize.height *=1.1;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
   // CGContextTranslateCTM(context, 0, im.size.height);
    CGContextTranslateCTM(context, 0, im.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextRotateCTM(context, rotationAngel);
    
   //CGContextDrawImage(context,CGRectMake(0,0, imageSize.width, imageSize.height),im.CGImage);
    CGContextDrawImage(context, (CGRect){{}, im.size}, im.CGImage);
    UIImage *rotatedImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    UIGraphicsEndImageContext();
    return rotatedImage;
}

/*
+(UIImageView *)rotateImageView:(UIImage *)im
               rotation:(double)rotationAngel
{
    CGSize imageSize = im.size;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // CGContextTranslateCTM(context, 0, im.size.height);
    CGContextTranslateCTM(context, im.size.width/2, im.size.height/2);
    CGContextScaleCTM(context, 1, -1);
    CGContextRotateCTM(context, rotationAngel);
    
    CGContextDrawImage(context,CGRectMake(0, 0, imageSize.width, imageSize.height),im.CGImage);
    UIImageView *rotatedImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    UIGraphicsEndImageContext();
    return rotatedImage;
}
*/

@end
