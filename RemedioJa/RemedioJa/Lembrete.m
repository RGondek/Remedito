//
//  Lembrete.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "Lembrete.h"
#import "SingletonLemb.h"

@implementation Lembrete{
    SingletonLemb *sL;
}

-(instancetype)initWithNome:(NSString*)n andData:(NSDate*)d{
    self = [super init];
    if (self) {
        sL = [SingletonLemb instance];
        _nome = n;
        _data = d;
        _ativo = YES;
        if ([[sL obterTodosLembretes] lastObject] == nil) {
            _index = 0;
        }
        else{
            Lembrete *l = [[sL obterTodosLembretes] lastObject];
            _index = (l.index + 1);
        }
    }
    return self;
}

@end
