//
//  StitcherUsingHomography.m
//  StitchMan
//
//  Created by he qiyun on 13-07-27.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "StitcherUsingHomography.h"


@implementation StitcherUsingHomography

+(UIImage *)stitching:(UIImage *)firstImage
             andImage:(UIImage *)secondImage
usingKeypointPairList:(KeypointPairList *)pairList{
    double *matrix = [StitcherUsingHomography getHomographicMatrix:firstImage
                                                          andImage:secondImage
                                             usingKeypointPairList:pairList];
    for (int x = 0; x<9; x++) {
        printf("matrix %d = %f \n",x,matrix[x]);
    }
    int newWidth;
    int newHeight;
    int expandLength = MAX(firstImage.size.height, firstImage.size.width);
    int i,j;
    int componentR,componentG,componentB,componentAlpha;
    int Red,G,B,Alpha;
    newWidth = firstImage.size.width + 2 * expandLength;
    newHeight = firstImage.size.height + 2 * expandLength;
    UIImage * finalFirstImage =[Stitcher rotateUIImage:firstImage
                                              rotation:0
                                            referenceX:0
                                            referenceY:0
                                                  setX:expandLength
                                                  setY:expandLength
                                             setHeight:newHeight
                                              setWidth:newWidth
                                ];
    unsigned char* firstRawData = [UIImageConverter UIImage2Data:finalFirstImage];
    unsigned char* secondRawData = [UIImageConverter UIImage2Data:secondImage];
    int x,y;
    coordinate *temp,*first,*second;
    temp = [[coordinate alloc] init];
    first = [[coordinate alloc] init];
    second = [[coordinate alloc] init];

    
    for (i=0;i<newHeight; i++) {
        for (j=0; j<newWidth; j++) {
            componentR = 4 * (i * newWidth + j);
            componentG = componentR + 1;
            componentB = componentG + 1;
            componentAlpha = componentB +1;
            temp->x = j;
            temp->y = i;
            temp = [coordinate changeToNormal:temp
                                       height:newHeight
                                        width:newWidth];
            
            if(temp->x==-172 && temp->y==46){
                int g=0;
                g++;
            }
            
            second->x = matrix[0]*temp->x + matrix[1]*temp->y + matrix[2];
            second->y = matrix[3]*temp->x + matrix[4]*temp->y + matrix[5];
            //test
            double z = matrix[6]*temp->x + matrix[7]*temp->y + matrix[8];
            second->x=second->x/z;
            second->y=second->y/z;
            
            second = [coordinate changeToReverse:second
                                          height:secondImage.size.height
                                           width:secondImage.size.width];
            //printf("x = %d, y = %d\n",second->x,second->y);
            if (second->x >-1 && second->x < secondImage.size.width && second->y > -1 && second->y < secondImage.size.height) {
                Red = 4 * (second->y * secondImage.size.width +second->x);
                G = Red+1;
                B = G+1;
                Alpha = B+1;
                if (i>expandLength && i<(expandLength+firstImage.size.height) && j>expandLength && j<(expandLength + firstImage.size.width)) {
                    
                    firstRawData[componentR] = (firstRawData[componentR] + secondRawData[Red])/2;
                    firstRawData[componentG] = (firstRawData[componentG] + secondRawData[G])/2;
                    firstRawData[componentB] = (firstRawData[componentB] + secondRawData[B])/2;
                    
                }
                else{
                    firstRawData[componentR] = secondRawData[Red];
                    firstRawData[componentG] = secondRawData[G];
                    firstRawData[componentB] = secondRawData[B];
                    firstRawData[componentAlpha] = 255;                
                }
            }
            else continue;
        }
    }
    
    
    
    UIImage *resultImage = [UIImageConverter data2UIImage:firstRawData
                                                   height:newHeight
                                                    width:newWidth];
    resultImage = [UIImagePruner pruneImage:resultImage];
    return resultImage;
}


+(double *)getHomographicMatrix:(UIImage *)firstImage
                       andImage:(UIImage *)secondImage
          usingKeypointPairList:(KeypointPairList *)pairList{
    int firstHeight = firstImage.size.height;
    int firstWidth = firstImage.size.width;
    int secondHeight = secondImage.size.height;
    int secondWidth = secondImage.size.width;
    NSMutableArray *list = [pairList getPairList];
    KeypointPair *pair1,*pair2,*pair3,*pair4;
    double *matrix;
    pair1 = [list objectAtIndex:0];
    pair2 = [list objectAtIndex:2];
    pair3 = [list objectAtIndex:4];
    pair4 = [list objectAtIndex:6];

    coordinate *p11,*p22,*p33,*p44;
    coordinate *p1,*p2,*p3,*p4;
    p11 = [[coordinate alloc] initWIthKeypointAndChange:pair1->keypoint1
                                                 height:firstHeight
                                                  width:firstWidth];
    p22 = [[coordinate alloc] initWIthKeypointAndChange:pair2->keypoint1
                                                 height:firstHeight
                                                  width:firstWidth];
    p33 = [[coordinate alloc] initWIthKeypointAndChange:pair3->keypoint1
                                                 height:firstHeight
                                                  width:firstWidth];
    p44 = [[coordinate alloc] initWIthKeypointAndChange:pair4->keypoint1
                                                 height:firstHeight
                                                  width:firstWidth];
    p1 = [[coordinate alloc] initWIthKeypointAndChange:pair1->keypoint2
                                                height:secondHeight
                                                 width:secondWidth];
    p2 = [[coordinate alloc] initWIthKeypointAndChange:pair2->keypoint2
                                                height:secondHeight
                                                 width:secondWidth];
    p3 = [[coordinate alloc] initWIthKeypointAndChange:pair3->keypoint2
                                                height:secondHeight
                                                 width:secondWidth];
    p4 = [[coordinate alloc] initWIthKeypointAndChange:pair4->keypoint2
                                                height:secondHeight
                                                 width:secondWidth];
    
    matrix = [Homography findHomography2DWithX1:p11->x
                                             Y1:p11->y
                                            X11:p1->x
                                            Y11:p1->y
                                             X2:p22->x
                                             Y2:p22->y
                                            X22:p2->x
                                            Y22:p2->y
                                             X3:p33->x
                                             Y3:p33->y
                                            X33:p3->x
                                            Y33:p3->y
                                             X4:p44->x
                                             Y4:p44->y
                                            X44:p4->x
                                            Y44:p4->y];
     
    
    return matrix;
}
@end
