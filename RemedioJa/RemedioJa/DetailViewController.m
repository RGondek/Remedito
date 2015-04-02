//
//  DetailViewController.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "DetailViewController.h"
#import "FamaciaCell.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize apRemedio, compRemedio, imgRemedio, nomeRemedio, pAteRemedio, pDeRemedio, tableViewF, itemR;

#pragma mark - Managing the detail item

- (void)configureView {
    // Update the user interface for the detail item.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemR.farmacias.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FamaciaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellF" forIndexPath:indexPath];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    Farmacia *itemF = itemR.farmacias[indexPath.row];
    
    [cell.img setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemF.imagem]]]];
    [cell.nome setText:itemF.nomeFarmacia];
    [cell.preco setText:[NSString stringWithFormat:@"R$ %.2f", itemF.preco]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    return cell;
}

@end
