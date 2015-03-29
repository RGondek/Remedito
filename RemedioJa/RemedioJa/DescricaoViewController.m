//
//  DescricaoViewController.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "DescricaoViewController.h"

@interface DescricaoViewController ()

@end

@implementation DescricaoViewController
@synthesize nome, endereco, farm;

- (void)viewDidLoad {
    [super viewDidLoad];
    nome.text = farm.nome;
    endereco.text = [NSString stringWithFormat:@"%@, %@", farm.endereco, farm.cep];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)voltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tracarRota:(id)sender {
    [self.delegate tracarRota:farm];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
