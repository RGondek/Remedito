//
//  Farm.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "Farm.h"

@implementation Farm

@synthesize nome, distancia, coordenada;

-(instancetype) initWithMapItem:(MKMapItem *)map eUserLocation:(MKUserLocation *)userLocation{
    
    self = [super init];
    if (self) {
        nome = map.placemark.name;
        coordenada = map.placemark.location.coordinate;
        CLLocation *fim = [[CLLocation alloc]initWithLatitude:map.placemark.location.coordinate.latitude longitude:map.placemark.location.coordinate.longitude];
        CLLocation *ini = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        CLLocationDistance dist = [fim distanceFromLocation:ini];
        distancia = dist;

    }
    return self;
    
}




@end
