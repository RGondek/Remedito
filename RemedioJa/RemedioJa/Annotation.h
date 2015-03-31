//
//  Annotation.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *titulo;

@end
