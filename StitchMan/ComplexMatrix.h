
#import <Foundation/Foundation.h>

#import "Complex.h"
#import "ImageMatrix.h"

@interface ComplexMatrix : NSObject
{
    complex *pNumbers;
    int width;
    int height;
}

- (id)initWithHeight:(int)height Width:(int)width;

- (id)initWithImageMatrix:(ImageMatrix *)im;

- (complex)getValueAtHeight:(int)height Width:(int)width;

- (int)getHeight;

- (int)getWidth;

- (void)setValueAtHeight:(int)height Width:(int)width Value:(complex)value;



- (void)print;
@end