//
//  Stitcher.m
//  StitchMan
//
//  Created by he qiyun on 13-07-08.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "Stitcher.h"

@implementation Stitcher

+(UIImage *)stitchImage:(UIImage *)firstImage
              withImage:(UIImage *)secondImage
  usingKeypointPairList:(KeypointPairList *)pairList{
    int newWidth;
    int newHeight;
    double theta;
    double scale;
    int expandLength = MAX(firstImage.size.height, firstImage.size.width);
    newWidth = firstImage.size.width + 2 * expandLength;
    newHeight = firstImage.size.height + 2 * expandLength;
    NSMutableArray *list = pairList.getPairList;
    KeypointPair *p1 = [list objectAtIndex:0];
    KeypointPair *p2 = [list objectAtIndex:1];
   // KeypointPair *p3 = [list objectAtIndex:2];
    theta = [Stitcher getTheta:p1 p2:p2];
    printf("theta = %f\n",theta);
    //theta = 0;
    //scale = 1;
    scale = [Stitcher getScale:p1 p2:p2];
    printf("sclae = %f\n",scale);
    UIImage *scaledSecondImage = [Stitcher changeScale:secondImage
                                                 scale:scale];
    //UIImage * finalFirstImage = [Stitcher fillImage:firstImage];
    UIImage * finalFirstImage =[Stitcher rotateUIImage:firstImage
                                              rotation:0
                                            referenceX:0
                                            referenceY:0
                                                  setX:expandLength
                                                  setY:expandLength
                                             setHeight:newHeight
                                              setWidth:newWidth
                                ];
    
    
    UIImage * finalSecondImage = [Stitcher rotateUIImage:scaledSecondImage
                                                rotation:theta
                                              referenceX:p1->keypoint2->x * scale
                                              referenceY:p1->keypoint2->y * scale
                                                    setX:p1->keypoint1->x + expandLength
                                                    setY:p1->keypoint1->y + expandLength
                                               setHeight:newHeight
                                                setWidth:newWidth
                                  ];
    UIImage * resultImage = [UIImagePruner pruneImage:[Stitcher combineTwoImages:finalFirstImage
                                           secondImage:finalSecondImage]
                             ];
    
    //scaledSecondImage = nil;
    //finalFirstImage = nil;
    //finalSecondImage = nil;
    
    return resultImage;
    //return finalSecondImage;
    //return finalFirstImage;
    //return scaledSecondImage;
}

+(UIImage *)combineTwoImages:(UIImage *)firstImage
                 secondImage:(UIImage *)secondImage{
    int height = firstImage.size.height;
    int width = firstImage.size.width;
    unsigned char* firstRawData = [UIImageConverter UIImage2Data:firstImage];
    unsigned char* secondRawData = [UIImageConverter UIImage2Data:secondImage];
    int componentR,componentG,componentB,componentAlpha;
    
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            componentR = (i * width + j) * 4;
            componentG = componentR + 1;
            componentB = componentG + 1;
            componentAlpha = componentB + 1;

            if (secondRawData[componentAlpha]!=0 && firstRawData[componentAlpha]!=0) {
                firstRawData[componentR] = ((int)firstRawData[componentR] + (int)secondRawData[componentR]) / 2;
                firstRawData[componentG] = ((int)firstRawData[componentG] + (int)secondRawData[componentG]) / 2;
                firstRawData[componentB] = ((int)firstRawData[componentB] + (int)secondRawData[componentB]) / 2;
            }
            else if (secondRawData[componentAlpha]!=0 && firstRawData[componentAlpha]==0){
                firstRawData[componentR] = secondRawData[componentR];
                firstRawData[componentG] = secondRawData[componentG];
                firstRawData[componentB] = secondRawData[componentB];
                firstRawData[componentAlpha] = secondRawData[componentAlpha];
            }
            else
                continue;
        }
    }
    UIImage * resultImage = [UIImageConverter data2UIImage:firstRawData
                                                height:height
                                                 width:width];
    return resultImage;
}

+(double)getTheta:(KeypointPair *)p1
               p2:(KeypointPair *)p2{
    int x11,x21,x12,x22,y11,y21,y12,y22;
    x11 = p1->keypoint1->x;
    x12 = p1->keypoint2->x;
    x21 = p2->keypoint1->x;
    x22 = p2->keypoint2->x;
    y11 = p1->keypoint1->y;
    y12 = p1->keypoint2->y;
    y21 = p2->keypoint1->y;
    y22 = p2->keypoint2->y;
    
    double degree1 = atan2(y21-y11,x11-x21);
    double degree2 = atan2(y22-y12,x12-x22);
    printf("x11 : %d,x21: %d,x12: %d,x22: %d,y11: %d,y21: %d,y12: %d,y22: %d \n",x11,x21,x12,x22,y11,y21,y12,y22);
    printf("degree1: %f   degree2: %f\n",degree1,degree2);
    double theta = degree1 - degree2;
    return theta;
}

/*
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
}*/

+(double)getScale:(KeypointPair *)p1
               p2:(KeypointPair *)p2
{
    int x11,x21,x12,x22,y11,y21,y12,y22;
    x11 = p1->keypoint1->x;
    x12 = p1->keypoint2->x;
    x21 = p2->keypoint1->x;
    x22 = p2->keypoint2->x;
    y11 = p1->keypoint1->y;
    y12 = p1->keypoint2->y;
    y21 = p2->keypoint1->y;
    y22 = p2->keypoint2->y;

    double distance1 = sqrt((x11-x21)*(x11-x21)+(y11-y21)*(y11-y21));
    double distance2 = sqrt((x12-x22)*(x12-x22)+(y12-y22)*(y12-y22));
    double scale = distance1/distance2;
    printf("scale:  %f\n",scale);
    return scale;
}

+(UIImage *)fillImage:(UIImage *)originalImage{
    CGImageRef imageRef = originalImage.CGImage;
    int width = CGImageGetWidth(imageRef);
    int height = CGImageGetHeight(imageRef);
    unsigned char *rawData = malloc(height * width * sizeof(unsigned char));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0,0,width,height), imageRef);
    CGContextRelease(context);
    
    int expandLength = MAX(height,width);
    unsigned char* newData = [Stitcher expandRawData:rawData
                                              height:height
                                               width:width
                                        expandLength:expandLength];

    int newHeight = height + 2 * expandLength;
    int newWidth = width + 2 * expandLength;
    CGContextRef bitmapContext = CGBitmapContextCreate(newData, newWidth, newHeight, 8, 4 * newWidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CFRelease(colorSpace);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    free(rawData);
    rawData=NULL;
    //free(newData);
    //newData=NULL;
    
    return resultImage;
    
}

+(unsigned char*)expandRawData:(unsigned char*)rawData
                        height:(int) height
                         width:(int) width
                  expandLength:(int) expandLength{
    int newHeight = height + 2 * expandLength;
    int newWidth = width + 2 * expandLength;
    int num=0;
    unsigned char* newData = malloc(newHeight * newWidth * 4 * sizeof(unsigned char));
    
    for(int i=0;i<newHeight;i++){
        for(int j=0;j<newWidth;j++){
            num = 4 * (i * newWidth + j);
            if (i < expandLength || i > height+expandLength-1 || j<expandLength || j> width + expandLength-1 ) {
                newData[num] = 0;
                newData[num+1] = 0;
                newData[num+2] = 0;
                newData[num+3] = 0;
            }
            
            else{
                newData[num] = rawData[4 * ((i - expandLength) *width + (j - expandLength))];
                newData[num+1] = rawData[4 * ((i - expandLength) *width + (j - expandLength)) +1];
                newData[num+2] = rawData[4 * ((i - expandLength) *width + (j - expandLength)) +2];
                newData[num+3] = 1;//rawData[4 * ((i - expandLength) *width + (j - expandLength)) +3];
            }
        }
     }
    return newData;
}

+ (UIImage*)mergeTheImage:(UIImage*)first withImage:(UIImage*)second
{
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    int expandLength = MAX(secondHeight, secondWidth);
    CGSize mergedSize = CGSizeMake(firstWidth + 2 * expandLength, firstHeight+ 2 * expandLength);
    
    UIGraphicsBeginImageContext(mergedSize);
    
    UIImage * expandedImage = [Stitcher fillImage:second];
    UIImage * rotatedImage = [Stitcher rotateImage:expandedImage rotation:0.3];
    //Draw images onto the context
    [first drawInRect:CGRectMake(expandLength, expandLength, firstWidth, firstHeight)];
    //[second drawInRect:CGRectMake(firstWidth, 0, secondWidth, secondHeight)];
    [rotatedImage drawInRect:CGRectMake(expandLength, expandLength, 3*secondWidth, 3*secondHeight)];
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}



+(UIImage *)rotateImage:(UIImage *)im
               rotation:(double)rotationAngel
{
    CGSize imageSize = im.size;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, im.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextRotateCTM(context, rotationAngel);
    
    //CGContextDrawImage(context,CGRectMake(0,0, imageSize.width, imageSize.height),im.CGImage);
    CGContextDrawImage(context, (CGRect){{}, im.size}, im.CGImage);
    UIImage *rotatedImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    UIGraphicsEndImageContext();
    return rotatedImage;
}

+(UIImage *)changeScale:(UIImage *)im
                  scale:(double)scale{
    CGSize imageSize = im.size;
    imageSize.width = imageSize.width * scale;
    imageSize.height = imageSize.height * scale;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, scale * im.size.height);
    CGContextScaleCTM(context, scale, -scale);
    CGContextDrawImage(context, (CGRect){{}, im.size}, im.CGImage);
    UIImage *scaledImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(UIImage *)rotateUIImage:(UIImage *)originalImage
                 rotation:(double)rotationAngel
               referenceX:(int) x
               referenceY:(int) y
                     setX:(int) xx
                     setY:(int) yy
                setHeight:(int) newHeight
                 setWidth:(int) newWidth
{
    int width = originalImage.size.width;
    int height = originalImage.size.height;
    printf("width : %d\nheight : %d\n",width,height);
    unsigned char* rawData = [UIImageConverter UIImage2Data:originalImage];
    unsigned char* newData = [Stitcher rotateRawData:rawData
                                              height:height
                                               width:width
                                          referenceX:x
                                          referenceY:y
                                                setX:xx
                                                setY:yy
                                           setHeight:newHeight
                                            setWidth:newWidth
                                           rotatioon:rotationAngel];
    
    UIImage *result = [UIImageConverter data2UIImage:newData
                                              height:newHeight
                                               width:newWidth];
    return result;
}

+(unsigned char*)rotateRawData:(unsigned char *)rawData
                        height:(int) height
                         width:(int) width
                    referenceX:(int) x
                    referenceY:(int) y
                          setX:(int) xx
                          setY:(int) yy
                     setHeight:(int) newHeight
                      setWidth:(int) newWidth
                     rotatioon:(double) theta{
    unsigned char* newData = malloc(newHeight * newWidth * 4);
    memset(newData, newHeight*newWidth*4, 0);

    for (int i = 0; i < newHeight; i++) {
        for (int j = 0; j<newWidth; j++) {
            int distance = pow((yy-i)*(yy-i) + (xx-j)*(xx-j), 0.5);
            double newrf = atan2(yy-i,j-xx)+1.57;
            double rf = newrf - theta;
            int originalX = x + distance*sin(rf);
            int originalY = y + distance*cos(rf);
            int originalPosition = (originalY * width + originalX)*4;
            int newPosition = (i*newWidth+j)*4;
            if (originalX>=0 && originalX<width && originalY>=0 && originalY<height) {
                newData[newPosition] = rawData[originalPosition];
                newData[newPosition+1] = rawData[originalPosition+1];
                newData[newPosition+2] = rawData[originalPosition+2];
                newData[newPosition+3] = rawData[originalPosition+3];

            }
        }
    }
    
    /*
    for (int i = 0; i < newHeight; i++) {
        for (int j = 0; j<newWidth; j++) {
            int distance = pow((yy-i)*(yy-i) + (xx-j)*(xx-j), 0.5);
            //double newrf = atan2(yy-i,j-xx)+1.57;
            double newrf = atan2(yy-i,xx-j);

            double rf = newrf - theta;
            double originalX = x + distance*sin(rf);
            double originalY = y + distance*cos(rf);
            int originalPosition = (originalY*width+originalX)*4;
            int newPosition = (i*newWidth+j)*4;
            
            if (originalX>=0 && originalX<width && originalY>=0 && originalY<height) {
                int highX = ceil(originalX);
                int lowX = floor(originalX);
                int highY = ceil(originalY);
                int lowY = floor(originalY);
                double ll = [Stitcher getAbsolute:(originalY - highY)*(originalX - highX)];
                double lh = [Stitcher getAbsolute:(originalY - highY)*(originalX - lowX)];
                double hl = [Stitcher getAbsolute:(originalY - lowY)*(originalX - highX)];
                double hh = [Stitcher getAbsolute:(originalY - lowY)*(originalX - lowX)];
                double total = ll+lh+hl+hh;
                ll = ll/total;
                lh = lh/total;
                hl = hl/total;
                hh = hh/total;
                int originalPosition1 = (lowY * width + lowX)*4;
                int originalPosition2 = (lowY * width + highX)*4;
                int originalPosition3 = (highY * width + lowX)*4;
                int originalPosition4 = (lowY * width + highX)*4;

                newData[newPosition] = ll * rawData[originalPosition1]+lh*rawData[originalPosition2]+hl*rawData[originalPosition3]+hh*rawData[originalPosition4];
                newData[newPosition+1] = ll * rawData[originalPosition1+1]+lh*rawData[originalPosition2+1]+hl*rawData[originalPosition3+1]+hh*rawData[originalPosition4+1];
                newData[newPosition+2] = ll * rawData[originalPosition1+2]+lh*rawData[originalPosition2+2]+hl*rawData[originalPosition3+2]+hh*rawData[originalPosition4+2];
                newData[newPosition+3] = rawData[originalPosition1+3];
                
            }
        }
    }*/
    
 /*   for (int i = 0; i < height; i++) {
        for (int j = 0; j<width; j++) {
            distance = pow((y-i)*(y-i)+(j-x)*(j-x),0.5);
            double rf = atan2(y-i,j-x)+1.57;
            double newrf = rf + theta;
            int newX = xx + sin(newrf)*distance;
            int newY = yy + cos(newrf)*distance;
            int newPosition = 4*(newY*newWidth+newX);
            int oldPosition = 4*(i*width + j);
            newData[newPosition]=rawData[oldPosition];
            newData[newPosition+1]=rawData[oldPosition+1];
            newData[newPosition+2]=rawData[oldPosition+2];
            newData[newPosition+3]=rawData[oldPosition+3];
        }
    }*/
    return newData;
}


+(double)getAbsolute:(double)num{
    if (num<0) {
        num = -num;
    }
    return num;
}

@end
