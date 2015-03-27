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

@implementation LembreteViewController
@synthesize dataPicker, campoTexto;

- (void)viewDidLoad {
    [super viewDidLoad];
    campoTexto.delegate = self;
    [campoTexto setReturnKeyType:UIReturnKeyDone];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
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
    UIApplication *application = [UIApplication sharedApplication];
    NSDate *dataP = [dataPicker date];
    NSTimeInterval time = floor([dataP timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    NSDate *horario = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    if ([campoTexto.text isEqualToString:@""]) {
        campoTexto.text = @"Padrão";
    }
    
    NSString *campoRemedio = [NSString stringWithFormat:@"Tomar remédio: %@", campoTexto.text];
    
    UILocalNotification *notificacao = [[UILocalNotification alloc] init];
    notificacao.fireDate = horario;
    notificacao.alertBody = campoRemedio;
    notificacao.soundName = UILocalNotificationDefaultSoundName;
    notificacao.timeZone = [NSTimeZone defaultTimeZone];
    
    notificacao.repeatInterval = NSCalendarUnitMinute;
    
    notificacao.applicationIconBadgeNumber = 1;
    
    [application scheduleLocalNotification:notificacao];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)botaoCancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
