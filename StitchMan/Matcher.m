//
//  Matcher.m
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "Matcher.h"

@implementation Matcher

+(KeypointPairList *)getKeypointPairList:(KeypointVector *) keypointVector1
                    secondKeypointVector:(KeypointVector *) keypointVector2
__attribute((ns_returns_retained))
{
    int length1 = [keypointVector1 getLength];
    int length2 = [keypointVector2 getLength];
    int i,j;
    double euclidianDistance, minDistance, secondMinDistance;
    int MinIndex, secondMinIndex;
    NSMutableArray * pairList = [[NSMutableArray alloc] init];
    KeypointPairList * result;
    
    
    for (i=0; i<length1; i++) {
        
        minDistance = [Matcher getEuclidianDistance:[keypointVector1->keypoints objectAtIndex:i]//keypointVector1 getKeypointAtIndex:i
                                          keypoint2:[keypointVector2->keypoints objectAtIndex:0]];
        secondMinDistance = minDistance;
        MinIndex = 0;
        secondMinIndex = 0;
        
        for (j=0; j<length2; j++) {
            euclidianDistance = [Matcher getSquaredEuclidianDistance:[keypointVector1->keypoints objectAtIndex:i]
                                                           keypoint2:[keypointVector2->keypoints objectAtIndex:j]];
        
            if (euclidianDistance < minDistance) {
                secondMinDistance = minDistance;
                minDistance = euclidianDistance;
                secondMinIndex = MinIndex;
                MinIndex = j;
            }
        }
        
        if(minDistance < 0.36 * secondMinIndex){
        KeypointPair * keypointPair;
        keypointPair = [[KeypointPair alloc] initPair:[keypointVector1->keypoints objectAtIndex:i]
                                       secondKeypoint:[keypointVector2->keypoints objectAtIndex:MinIndex]
                                    euclidianDistance:minDistance];
        
        [pairList addObject:keypointPair];
        }
        
        else continue;
    }
    
    //sort pair list with the increasing distance
    [pairList sortUsingComparator:^NSComparisonResult(KeypointPair * p1, KeypointPair * p2) {
        if (p1->euclidianDistance > p2->euclidianDistance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (p1->euclidianDistance < p2->euclidianDistance) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    
    /*  output pairlist 
    for(int xxx = 0;xxx<[pairList count];xxx++){
        printf("distance: %f",((KeypointPair *)[pairList objectAtIndex:xxx])->euclidianDistance);
    
    }
    */
    
    result = [[KeypointPairList alloc] initWithNSMutableArray:pairList];
    return result;
    
}

+(double)getEuclidianDistance:(Keypoint *)p1
                    keypoint2:(Keypoint *)p2
{
    int i,j,k;
    double temp=0;
    double euclidianDistance;
    for (i=0;i<4;i++) {
        for (j=0;j<4;j++){
            for (k=0;k<8;k++){
                temp+=pow(p1->descriptor[i][j][k] - p2->descriptor[i][j][k] , 2);
            }
        }
    }
    euclidianDistance = pow(temp,0.5);

    return euclidianDistance;
}

+(double)getSquaredEuclidianDistance:(Keypoint *)p1
                           keypoint2:(Keypoint *)p2
{
    int i,j,k;
    double temp=0;
    double squaredEuclidianDistance;
    for (i=0;i<4;i++) {
        for (j=0;j<4;j++){
            for (k=0;k<8;k++){
                temp+=pow(p1->descriptor[i][j][k] - p2->descriptor[i][j][k] , 2);
            }
        }
    }
    squaredEuclidianDistance = temp;
    
    return squaredEuclidianDistance;
}



@end
