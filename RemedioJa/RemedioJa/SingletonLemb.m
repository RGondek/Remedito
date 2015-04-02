//
//  SingletonLemb.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "SingletonLemb.h"

@implementation SingletonLemb

@synthesize meuRealm;

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
        meuRealm=[RLMRealm defaultRealm];
    }
    return self;
}

-(void) salvarLembrete:(NSString *)nome andData:(NSDate *)data{
    Lembrete *l=[[Lembrete alloc]initWithNome:nome andData:data];
    [meuRealm beginWriteTransaction];
    [meuRealm addObject:l];
    [meuRealm commitWriteTransaction];
    
}

-(NSArray *) obterTodosLembretes{
    RLMResults *resultado=[Lembrete allObjects];
    resultado = [resultado sortedResultsUsingProperty:@"data" ascending:YES];
    NSMutableArray *itens=[[NSMutableArray alloc]init];
    for(Lembrete *l in resultado){
        [itens addObject:l];
    }
    return itens;
}

-(Lembrete *) obterObjIndex:(int)i{
    RLMResults *resultado=[Lembrete objectsWhere:[NSString stringWithFormat:@"index=%d", i]];
    for(Lembrete *l in resultado){
        if(l.index ==i){
            return l;
        }
    }
    return nil;
}

-(void)alterarLembreteNome:(NSString *)n eData:(NSDate*)d Index:(int)i{
    Lembrete *l = [self obterObjIndex:i];
    [meuRealm beginWriteTransaction];
    l.nome = n;
    l.data = d;
    [meuRealm commitWriteTransaction];
}

-(void)alterarEstado:(BOOL)status Index:(int)i{
    Lembrete *l = [self obterObjIndex:i];
    [meuRealm beginWriteTransaction];
    l.ativo = status;
    [meuRealm commitWriteTransaction];
}

-(void) removeLembreteIndex:(int)i{
    Lembrete *l = [self obterObjIndex:i];
    [meuRealm beginWriteTransaction];
    [meuRealm deleteObject:l];
    [meuRealm commitWriteTransaction];
}

@end
