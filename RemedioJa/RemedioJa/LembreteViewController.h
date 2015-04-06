//
//  LembreteViewController.h
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingletonLemb.h"
#import "Lembrete.h"

@interface LembreteViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UITextField *campoTexto;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnIntervalo;
@property (weak, nonatomic) IBOutlet UILabel *lblIntervalo;

@property Lembrete *lemb;
@property int index;

- (IBAction) botaoSalvar:(id)sender;
- (IBAction) botaoCancelar:(id)sender;

@end
