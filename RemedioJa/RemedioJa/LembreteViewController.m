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

@synthesize dataPicker, campoTexto, lemb, index, btnIntervalo, lblIntervalo;

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
        switch (lemb.intervalo) {
            case 1:
                [btnIntervalo setSelectedSegmentIndex:0];
                break;
            case 2:
                [btnIntervalo setSelectedSegmentIndex:1];
                break;
            case 4:
                [btnIntervalo setSelectedSegmentIndex:2];
                break;
            case 6:
                [btnIntervalo setSelectedSegmentIndex:3];
                break;
            case 8:
                [btnIntervalo setSelectedSegmentIndex:4];
                break;
            case 12:
                [btnIntervalo setSelectedSegmentIndex:5];
                break;
            case 24:
                [btnIntervalo setSelectedSegmentIndex:6];
                break;
        }
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
    else if ((btnIntervalo.selectedSegmentIndex < 0) || (btnIntervalo.selectedSegmentIndex > 6)){
        [lblIntervalo setText:@"Selecione um intervalo de repetição"];
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
    int inter = 24;
    NSDate *dataP = [dataPicker date];
    NSTimeInterval time = floor([dataP timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    NSDate *horario = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    switch (btnIntervalo.selectedSegmentIndex) {
        case 0:
            inter = 1;
            break;
        case 1:
            inter = 2;
            break;
        case 2:
            inter = 4;
            break;
        case 3:
            inter = 6;
            break;
        case 4:
            inter = 8;
            break;
        case 5:
            inter = 12;
            break;
        case 6:
            inter = 24;
            break;
    }
    if (lemb == nil) {
        [sL salvarLembrete:campoTexto.text andData:horario andIntervalo:inter];
    }
    else {
        // Altera Lembrete
        [sL alterarLembreteNome:campoTexto.text eData:horario Index:lemb.index eIntervalo:inter];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
