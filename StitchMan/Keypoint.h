
#import <Foundation/Foundation.h>

@interface Keypoint : NSObject
{
@public
    int x;
    int y;
    
    int x_oct;
    int y_oct;
    
    int octave_num;
    int interval_num;
    
    double descriptor[4][4][8];
    
    double theta;
    
}

- (id)initWithX:(int)x Y:(int)y X_OCT:(int)x_oct Y_OCT:(int)y_oct
         Octave:(int)octave_num Interval:(int)interval_num;

- (id)initWithKeypoint:(Keypoint *)keypoint;

- (void)print;

@end