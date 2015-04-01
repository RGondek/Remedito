//
//  LembreteViewController.m
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "LembreteViewController.h"
#import "SingletonLemb.h"
#import "Lembrete.h"

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    if (lemb != nil) {
        [campoTexto setText:lemb.nome];
        [dataPicker setDate:lemb.data];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [campoTexto resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [campoTexto setPlaceholder: @"Digite o nome do remédio"];
    }
    else {
        [self salvar];
    }
}

- (IBAction)botaoCancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)salvar{
    
    UIApplication *application = [UIApplication sharedApplication];
    NSDate *dataP = [dataPicker date];
    NSTimeInterval time = floor([dataP timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    NSDate *horario = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    if (lemb == nil) {
//       Lembrete *lembrete = [[Lembrete alloc]init];
        [sL salvarLembrete:campoTexto.text andData:horario];
//        [sL.lembretes addObject:lembrete];
        
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
        [[UIApplication sharedApplication] cancelLocalNotification:notificacao];

        lemb.nome = campoTexto.text;
        lemb.data = horario;
        [sL alterarObj:lemb Index:lemb.index];
        
    }
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
