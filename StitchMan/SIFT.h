
#import <Foundation/Foundation.h>

#import "ImageMatrix.h"
#import "Pyramid.h"
#import "KeypointVector.h"

@interface SIFT : NSObject
{
    @public
    ImageMatrix *imageMatrix;
    Pyramid *pyramid;
    KeypointVector *keypointVector;
}

- (id)initWithImageMatrix:(ImageMatrix *)im;

- (void)buildPyramid;

- (void)detectKeypoints;

- (ImageMatrix *)originalImage;

- (ImageMatrix *)output __attribute((ns_returns_retained));

@end