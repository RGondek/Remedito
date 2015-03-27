//
//  HorarioTableViewCell.h
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorarioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *horario;
@property (weak, nonatomic) IBOutlet UILabel *nomedoRemedio;
@property (strong, nonatomic) IBOutlet UISwitch *btnAtivo;

@end
