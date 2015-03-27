//
//  SingletonLemb.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonLemb : NSObject

@property NSMutableArray *lembretes;

+(SingletonLemb*) instance;

@end
