//
//  UIImageConverter.h
//  StitchMan
//
//  Created by he qiyun on 13-07-09.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageConverter : NSObject

+(UIImage *)data2UIImage:(unsigned char*)rawData
                  height:(int)height
                   width:(int)width;

+(unsigned char*)UIImage2Data:(UIImage *)im;

@end
