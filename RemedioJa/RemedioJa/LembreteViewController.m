//
//  LembreteViewController.m
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "LembreteViewController.h"

@interface LembreteViewController ()
@end

@implementation LembreteViewController {
    SingletonLemb *sL;
}

@synthesize dataPicker, campoTexto, lemb, index;

- (void)viewDidLoad {
    [super viewDidLoad];
    sL = [SingletonLemb instance];
    campoTexto.delegate = self;
    [campoTexto setReturnKeyType:UIReturnKeyDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    if (lemb != nil) {
        [campoTexto setText:lemb.nome];
        [dataPicker setDate:lemb.data];
    }
}

#pragma mark - Actions

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [campoTexto resignFirstResponder];
    return YES;
}

- (IBAction)botaoSalvar:(id)sender {
    if ([campoTexto.text isEqualToString:@""]) {
        float valor = 15;
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position.x"];
        [shake setDuration:0.075];
        [shake setRepeatCount:2];
        [shake setAutoreverses:YES];
        [shake setFromValue:[NSNumber numberWithFloat:campoTexto.center.x - valor]];
        [shake setFromValue:[NSNumber numberWithFloat:campoTexto.center.x + valor]];
        [campoTexto.layer addAnimation:shake forKey:@"shake"];
        [campoTexto setPlaceholder: NSLocalizedString(@"Digite o nome do remédio", nil)];
    }
    else {
        [self salvar];
    }
}

- (IBAction)botaoCancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Métodos

-(void)salvar{
    UIApplication *application = [UIApplication sharedApplication];
    NSDate *dataP = [dataPicker date];
    NSTimeInterval time = floor([dataP timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    NSDate *horario = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    if (lemb == nil) {
        [sL salvarLembrete:campoTexto.text andData:horario];        
    }
    else {
        // Apagar notificacao
        UILocalNotification *notificacao = [[UILocalNotification alloc] init];
        notificacao.fireDate = lemb.data;
        notificacao.alertBody = lemb.nome;
        notificacao.soundName = UILocalNotificationDefaultSoundName;
        notificacao.timeZone = [NSTimeZone defaultTimeZone];
        notificacao.repeatInterval = NSCalendarUnitDay;
        notificacao.applicationIconBadgeNumber = 1;
        [application cancelLocalNotification:notificacao];

        [sL alterarLembreteNome:campoTexto.text eData:horario Index:lemb.index];
        
    }
    // Cria notificação
    UILocalNotification *notificacao = [[UILocalNotification alloc] init];
    notificacao.fireDate = horario;
    notificacao.alertBody = campoTexto.text;
    notificacao.soundName = UILocalNotificationDefaultSoundName;
    notificacao.timeZone = [NSTimeZone defaultTimeZone];
    notificacao.repeatInterval = NSCalendarUnitDay;
    notificacao.applicationIconBadgeNumber = 1;
    [application scheduleLocalNotification:notificacao];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
