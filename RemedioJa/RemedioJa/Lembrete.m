//
//  Lembrete.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/27/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "Lembrete.h"
#import "SingletonLemb.h"

@implementation Lembrete{
    SingletonLemb *sL;
}

@synthesize nome, data, ativo, index, intervalo;

-(instancetype)initWithNome:(NSString*)n andData:(NSDate*)d andIntervalo:(int)i{
    self = [super init];
    if (self) {
        sL = [SingletonLemb instance];
        nome = n;
        data = d;
        ativo = YES;
        intervalo = i;
        if ([[sL obterTodosLembretes] lastObject] == nil) {
            index = 0;
        }
        else{
            Lembrete *l = [[sL obterTodosLembretes] lastObject];
            index = (l.index + 1);
        }
    }
    return self;
}

-(void) criarNotificacao{
    NSDate *novaData = data;
    for (int i = 0; i < (24/intervalo); i++) {
        UILocalNotification *notificacao = [[UILocalNotification alloc] init];
        notificacao.fireDate = novaData;
        notificacao.alertBody = nome;
        notificacao.soundName = UILocalNotificationDefaultSoundName;
        notificacao.timeZone = [NSTimeZone defaultTimeZone];
        notificacao.repeatInterval = NSCalendarUnitDay;
        notificacao.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notificacao];
        novaData = [NSDate dateWithTimeInterval:(intervalo*3600) sinceDate:novaData];
    }
}

-(void) deletarNotificacao{
    NSDate *novaData = data;
    for (int i = 0; i < (24/intervalo); i++) {
        UILocalNotification *notificacao = [[UILocalNotification alloc] init];
        notificacao.fireDate = novaData;
        notificacao.alertBody = nome;
        notificacao.soundName = UILocalNotificationDefaultSoundName;
        notificacao.timeZone = [NSTimeZone defaultTimeZone];
        notificacao.repeatInterval = NSCalendarUnitDay;
        notificacao.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] cancelLocalNotification:notificacao];
        novaData = [NSDate dateWithTimeInterval:(intervalo*3600) sinceDate:novaData];
    }
}

@end
