
#import <Foundation/Foundation.h>

#import "ImageMatrix.h"
#import "Pyramid.h"

@interface Derivative : NSObject

+ (double *)deriv3D:(Pyramid *)pyramid Octave:(int)octave_num Interval:(int)interval_num
                  X:(int)x Y:(int)y;

+ (double *)hessian3D:(Pyramid *)pyramid Octave:(int)octave_num Interval:(int)interval_num
                    X:(int)x Y:(int)y;

@end