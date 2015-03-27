//
//  Lembrete.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "Lembrete.h"

@implementation Lembrete

-(instancetype)initWithNome:(NSString*)n andData:(NSDate*)d{
    self = [super init];
    if (self) {
        _nome = n;
        _data = d;
        _ativo = YES;
    }
    return self;
}

@end
