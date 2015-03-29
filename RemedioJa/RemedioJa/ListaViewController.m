//
//  ListaViewController.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//
#import "MapViewController.h"
#import "ListaViewController.h"
#import "ListaTableViewCell.h"
#import "DescricaoViewController.h"
#import "Farm.h"

@interface ListaViewController ()

@end

@implementation ListaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _matchingItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListaTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"ListaTableCell" forIndexPath:indexPath];
    Farm *farm = _matchingItems[[indexPath row]];
    cell.nome.text = farm.nome;
    UIButton *rota = [[UIButton alloc] init];
    rota.frame = CGRectMake(20, 12, 30, 25);
    rota.tag = indexPath.row;
    [rota setImage:[UIImage imageNamed:@"carro.png"] forState:UIControlStateNormal];
    [rota addTarget:self action:@selector(tracarRota:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:rota];
    return cell;
}
- (IBAction)voltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)tracarRota:(id)sender {
    if ([sender class] == [Farm class])
        [self.delegate tracarRota:sender];
    else
        [self.delegate tracarRota:_matchingItems[[sender tag]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DescricaoViewController *descricaoViewController = [segue destinationViewController];
    MapViewController *mapViewController = [segue sourceViewController];
    descricaoViewController.delegate = mapViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    descricaoViewController.farm = _matchingItems[[indexPath row]];
}

@end
