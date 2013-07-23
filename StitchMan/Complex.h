
#import <Foundation/Foundation.h>

typedef struct{
    float real;
    float imaginary;
}complex;

@interface Complex : NSObject

+ (complex)ComplexCalc:(complex)number1 add:(complex)number2;

+ (complex)ComplexCalc:(complex)number1 subtract:(complex)number2;

+ (complex)ComplexCalc:(complex)number1 multiply:(complex)number2;

+ (complex)ComplexCalc:(complex)number1 divide:(complex)number2;

+ (complex)AdjointOf:(complex)number1;

+ (void)print:(complex)number;

@end