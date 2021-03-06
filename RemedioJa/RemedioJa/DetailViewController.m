//
//  DetailViewController.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

@synthesize apRemedio, compRemedio, imgRemedio, nomeRemedio, pAteRemedio, pDeRemedio, tableViewF, itemR;

#pragma mark - Configurando detalhes do item

- (void)configureView {
    // Define os campos do Remédio
    [nomeRemedio setText:itemR.nomeRemedio];
    [apRemedio setText:itemR.apresentacao];
    [compRemedio setText:itemR.composto];
    Farmacia *itemF = [itemR.farmacias firstObject];
    [pDeRemedio setText:[NSString stringWithFormat:@"R$ %.2f", itemF.preco]];
    itemF = [itemR.farmacias lastObject];
    [pAteRemedio setText:[NSString stringWithFormat:@"R$ %.2f", itemF.preco]];
    [imgRemedio setImage:itemR.imagem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableViewF setDelegate:self];
    [tableViewF setDataSource:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemR.farmacias.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FarmaciaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellF" forIndexPath:indexPath];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    Farmacia *itemF = itemR.farmacias[indexPath.row];
    
    [cell.img setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemF.imagem]]]];
    [cell.nome setText:itemF.nomeFarmacia];
    [cell.preco setText:[NSString stringWithFormat:@"R$ %.2f", itemF.preco]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Mensagem de redirecionamento
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Redirecionamento", nil) message:NSLocalizedString(@"Deseja prosseguir?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) otherButtonTitles:@"OK", nil];
    [alerta show];
    [alerta setTag:indexPath.row];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Redireciona ao Safari
    if(buttonIndex == 1){
        Farmacia *itemF = itemR.farmacias[alertView.tag];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:itemF.url]];
    }
}


@end
