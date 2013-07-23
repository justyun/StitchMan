//
//  KeypointPairList.m
//  StitchMan
//
//  Created by he qiyun on 13-07-06.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "KeypointPairList.h"

@implementation KeypointPairList


-(id)initWithNSMutableArray:(NSMutableArray *)array{
    if(self = [super init]){
        pairList = array;
    }
    return self;
}

-(NSMutableArray *)getPairList{
    return pairList;
}

@end
