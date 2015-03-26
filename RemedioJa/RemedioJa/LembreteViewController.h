//
//  LembreteViewController.h
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LembreteViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)botaoSalvar:(id)sender;

@end
