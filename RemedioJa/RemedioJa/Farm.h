//
//  Farm.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Farm : NSObject{
    NSString *descricao;
}

@property NSString* nome;
@property CLLocationCoordinate2D coordenadas;
@property NSString *endereco;
@property NSString *cep;

-(instancetype) initWithNome:(NSString *)newNome andCoordenadas:(CLLocationCoordinate2D)newCoordenadas andEndereco:(NSString *)newEndereco andCep:(NSString *)newCep;

@end