//
//  SingletonLemb.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Lembrete.h"

@interface SingletonLemb : NSObject

@property RLMRealm *meuRealm;
@property NSMutableArray *lembretes;


+(SingletonLemb*) instance;
-(void) salvarLembrete:(NSString *)nome andData:(NSDate *)data;
-(NSArray *) obterTodosLembretes;
-(Lembrete *) obterObjIndex:(int)i;
-(void) alterarObj:(Lembrete*)lemb Index:(int)i;
-(void)alterarEstado:(BOOL)status Index:(int)i;

@end
