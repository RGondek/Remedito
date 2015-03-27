//
//  Lembrete.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lembrete : NSObject

@property NSString *nome;
@property NSDate *data;
@property BOOL ativo;

-(instancetype)initWithNome:(NSString*)n andData:(NSDate*)d;

@end
