//
//  Lembrete.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Lembrete : RLMObject

@property (nonatomic,strong) NSString *nome;
@property (nonatomic,strong) NSDate *data;
@property (nonatomic) BOOL ativo;
@property int index;

-(instancetype) initWithNome:(NSString*)n andData:(NSDate*)d;

@end
