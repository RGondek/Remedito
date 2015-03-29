//
//  Farm.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "Farm.h"

@implementation Farm

@synthesize nome, coordenadas, endereco, cep;

-(instancetype) initWithNome:(NSString *)newNome andCoordenadas:(CLLocationCoordinate2D)newCoordenadas andEndereco:(NSString *)newEndereco andCep:(NSString *)newCep{
    
    self = [super init];
    nome = newNome;
    coordenadas = newCoordenadas;
    endereco = newEndereco;
    cep = newCep;
    return self;
    
}




@end
