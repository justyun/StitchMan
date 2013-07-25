//
//  Complex.m
//  StitchMan
//
//  Created by wjy on 13-7-7.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Complex.h"

@implementation Complex

+ (complex)ComplexCalc:(complex)number1 add:(complex)number2
{
    complex result;
    result.real=number1.real+number2.real;
    result.imaginary=number1.imaginary+number2.imaginary;
    return result;
}

+ (complex)ComplexCalc:(complex)number1 subtract:(complex)number2
{
    complex result;
    result.real=number1.real-number2.real;
    result.imaginary=number1.imaginary-number2.imaginary;
    return result;
}

+ (complex)ComplexCalc:(complex)number1 multiply:(complex)number2
{
    complex result;
    result.real=number1.real*number2.real - number1.imaginary*number2.imaginary;
    result.imaginary=number1.real*number2.imaginary + number1.imaginary*number2.real;
    return result;
}

+ (complex)ComplexCalc:(complex)number1 divide:(complex)number2
{
    complex result;
    float a=pow(number2.real,2.0) + pow(number2.imaginary,2.0);
    result.real=(number1.real*number2.real + number1.imaginary*number2.imaginary)/a;
    result.imaginary=(number1.imaginary*number2.real - number1.real*number2.imaginary)/a;
    return result;
}

+ (complex)AdjointOf:(complex)number
{
    complex result;
    result.real=number.real;
    result.imaginary=-number.imaginary;
    return result;
}

+ (void)print:(complex)number
{
    printf("%.2f + %.2fi\n",number.real,number.imaginary);
}

@end
