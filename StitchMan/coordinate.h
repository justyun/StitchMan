//
//  coordinate.h
//  StitchMan
//
//  Created by he qiyun on 13-07-27.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keypoint.h"
@interface coordinate : NSObject
{
    @public
    int x;
    int y;
}

-(id)initWithKeypoint:(Keypoint *)keypoint;

-(id)initWIthKeypointAndChange:(Keypoint *)keypoint
                        height:(int)height
                         width:(int)width;

+(coordinate *)changeToNormal:(coordinate *)p
                       height:(int)height
                        width:(int)width;

+(coordinate *)changeToReverse:(coordinate *)p
                        height:(int)height
                         width:(int)width;

@end
