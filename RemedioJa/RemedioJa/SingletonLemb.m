//
//  SingletonLemb.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "SingletonLemb.h"
#import "Lembrete.h"

@implementation SingletonLemb

@synthesize meuRealm, lembretes;

static SingletonLemb *inst = nil;

#pragma mark - Singleton

+(SingletonLemb*) instance{
    if (inst == nil) {
        inst = [[SingletonLemb alloc] init];
    }
    return inst;
}

-(id) init {
    self = [super init];
    if (self) {
        lembretes = [[NSMutableArray alloc] init];
        meuRealm = [RLMRealm defaultRealm];
    }
    return self;
}

#pragma mark - REALM

-(void) salvarLembrete:(NSString *)nome andData:(NSDate *)data andIntervalo:(int)i{
    Lembrete *l = [[Lembrete alloc] initWithNome:nome andData:data andIntervalo:i];
    [meuRealm beginWriteTransaction];
    [meuRealm addObject:l];
    [meuRealm commitWriteTransaction];
    [l criarNotificacao];
}

-(NSArray *) obterTodosLembretes{
    RLMResults *resultado = [Lembrete allObjects];
    resultado = [resultado sortedResultsUsingProperty:@"data" ascending:YES];
    NSMutableArray *itens = [[NSMutableArray alloc] init];
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

-(void) alterarLembreteNome:(NSString *)n eData:(NSDate*)d Index:(int)i eIntervalo:(int)inter{
    Lembrete *l = [self obterObjIndex:i];
    [l deletarNotificacao];
    [meuRealm beginWriteTransaction];
    l.nome = n;
    l.data = d;
    l.intervalo = inter;
    [meuRealm commitWriteTransaction];
    [l criarNotificacao];
}

-(void) alterarEstado:(BOOL)status Index:(int)i{
    Lembrete *l = [self obterObjIndex:i];
    [meuRealm beginWriteTransaction];
    l.ativo = status;
    [meuRealm commitWriteTransaction];
    if (status) {
        [l criarNotificacao];
    }
    else{
        [l deletarNotificacao];
    }
}

-(void) removeLembreteIndex:(int)i{
    Lembrete *l = [self obterObjIndex:i];
    [l deletarNotificacao];
    [meuRealm beginWriteTransaction];
    [meuRealm deleteObject:l];
    [meuRealm commitWriteTransaction];
}

@end
