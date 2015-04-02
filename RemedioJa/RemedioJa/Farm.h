//
//  Farm.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Farm : NSObject{
    NSString *descricao;
}

@property NSString* nome;
@property CLLocationDistance distancia;
@property CLLocationCoordinate2D coordenada;

-(instancetype) initWithMapItem:(MKMapItem *)map eUserLocation:(MKUserLocation *)userLocation;

@end