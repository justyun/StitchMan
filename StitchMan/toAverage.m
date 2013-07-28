//
//  toAverage.m
//  StitchMan
//
//  Created by he qiyun on 13-07-26.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "toAverage.h"

@implementation toAverage

+(double)getAverageTheta:(KeypointPairList *)pairList
           ofFirstNPairs:(int)num{
    double totalTheta,averagedTheta;
    KeypointPair *p1,*p2;
    NSMutableArray *list = pairList.getPairList;
    double currentTheta, firstTheta, temp;
    int count = 1;
    p1 = [list objectAtIndex:0];
    p2 = [list objectAtIndex:1];
    firstTheta = [toAverage getTheta:p1
                                  p2:p2];
    totalTheta = firstTheta;
    
    for (int i=1; i<num-1; i++) {
        p1 = [list objectAtIndex:i];
        p2 = [list objectAtIndex:i+1];
        currentTheta = [toAverage getTheta:p1
                                        p2:p2];
        temp = currentTheta - firstTheta;
        if(temp > -0.1 && temp < 0.1){
            totalTheta += currentTheta;
            count++;
            printf("current total theta : %f   currentTheta : %f\n",totalTheta,currentTheta);
        }
        else continue;
    }
    p1 = nil;
    p2 = nil;
    averagedTheta = totalTheta / count;
    return averagedTheta;
}

+(KeypointPair *)getAverageReferencePoint:(KeypointPairList *)pairList
                        ofFirstNPairs:(int)num{
    double totalX1 = 0, totalY1 = 0;
    double totalX2 = 0, totalY2 = 0;
    double x1,y1,x2,y2;
    NSMutableArray *list = pairList.getPairList;
    KeypointPair *p;
    for (int i=0; i<num; i++) {
        p = [list objectAtIndex:i];
        totalX1 += p->keypoint1->x;
        totalY1 += p->keypoint1->y;
        totalX2 += p->keypoint2->x;
        totalY2 += p->keypoint2->y;
    }
    x1 = totalX1 / num;
    y1 = totalY1 / num;
    x2 = totalX2 / num;
    y2 = totalY2 / num;

    p->keypoint1->x = round(x1);
    p->keypoint1->y = round(y1);
    p->keypoint2->x = round(x2);
    p->keypoint2->y = round(y2);
    
    //printf("before round: %f  after round : %f\n",x1,p->keypoint1->x);
    return p;
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
    double theta = degree1 - degree2;
    return theta;
}


@end
