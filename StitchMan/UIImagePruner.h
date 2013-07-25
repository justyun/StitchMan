//
//  UIImagePruner.h
//  StitchMan
//
//  Created by he qiyun on 13-07-24.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stitcher.h"
#import "UIImageConverter.h"

@interface UIImagePruner : NSObject

+(UIImage *)pruneImage:(UIImage *)im;

@end
