//
//  FamaciaCell.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/26/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamaciaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nome;
@property (weak, nonatomic) IBOutlet UILabel *preco;

@end
