//
//  Remedio.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Remedio : NSObject

@property (nonatomic, copy) NSString *nomeRemedio;
@property (nonatomic, copy) NSString *imagem;
@property (nonatomic, copy) NSString *apresentacao;
@property (nonatomic, copy) NSString *composto;
@property (nonatomic, copy) NSString *lab;

@property (nonatomic, copy) NSArray *farmacias;

@property (nonatomic, copy) NSString *bulaUrl;

@end
