//
//  LembreteViewController.h
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lembrete.h"
#import "SingletonLemb.h"

@interface LembreteViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UITextField *campoTexto;
@property Lembrete *lemb;
@property int index;

- (IBAction)botaoSalvar:(id)sender;
- (IBAction)botaoCancelar:(id)sender;

@end
