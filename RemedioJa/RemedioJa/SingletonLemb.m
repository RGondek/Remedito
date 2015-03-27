//
//  SingletonLemb.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "SingletonLemb.h"

@implementation SingletonLemb

static SingletonLemb *inst = nil;

#pragma mark - Public Method

+(SingletonLemb*) instance{
    if (inst == nil) {
        inst = [[SingletonLemb alloc] init];
    }
    return inst;
}

-(id)init {
    self = [super init];
    if (self) {
        _lembretes = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
