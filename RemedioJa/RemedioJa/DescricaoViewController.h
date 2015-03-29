//
//  DescricaoViewController.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "Farm.h"

@interface DescricaoViewController : UIViewController

@property Farm *farm;
@property (weak, nonatomic) IBOutlet UILabel *nome;
@property (weak, nonatomic) IBOutlet UILabel *endereco;
@property (weak, nonatomic) id<MapViewDelegate> delegate;

- (IBAction)voltar:(id)sender;
- (IBAction)tracarRota:(id)sender;
@end
