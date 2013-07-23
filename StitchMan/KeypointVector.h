
#import <Foundation/Foundation.h>

#import "Pyramid.h"
#import "Keypoint.h"
#import "Derivative.h"

#define INTERPOLATION_ITERATION 5 //default 5
#define CONTRAST_THRESHOLD 0.04*255 //default 0.04*255
#define R 10 //default 10

@interface KeypointVector : NSObject
{
@public
    Pyramid *pyr;
    NSMutableArray *keypoints;
    NSMutableArray *duplicateKeypoints;
    int count1;
}

- (id)initWithPyramid:(Pyramid *)pyramid;

//- (Keypoint *)getKeypointAtIndex:(int)index __attribute((ns_returns_retained));

- (int)getLength;

- (void)output;

@end