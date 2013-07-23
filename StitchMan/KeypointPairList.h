//
//  KeypointPairList.h
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeypointPair.h"

@interface KeypointPairList : NSObject
{
    @public
    NSMutableArray * pairList;

}

-(id) initWithNSMutableArray:(NSMutableArray *)array;

-(NSMutableArray *)getPairList;

@end
