//
//  HorariosViewController.m
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "HorariosViewController.h"

@interface HorariosViewController ()
@end

@implementation HorariosViewController{
    Lembrete *lemb;
    SingletonLemb *sL;
    NSMutableArray *itens;
    UISwitch *theSwitch;
}

@synthesize tb;

- (void)viewDidLoad {
    [super viewDidLoad];
    sL = [SingletonLemb instance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    itens = [[NSMutableArray alloc] initWithArray:[sL obterTodosLembretes]];
    [tb reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [itens count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HorarioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    lemb = [itens objectAtIndex:indexPath.row];
    
    NSDateFormatter *dtForm = [[NSDateFormatter alloc] init];
    [dtForm setDateFormat:@"HH:mm"];
    
    [cell.btnAtivo setTag:indexPath.row];
    [cell.btnAtivo addTarget:self action:@selector(mudarEstado:) forControlEvents:UIControlEventValueChanged];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.btnAtivo setTag:indexPath.row];
    [cell.nomedoRemedio setText:lemb.nome];
    [cell.horario setText:[dtForm stringFromDate:lemb.data]];
    [cell.btnAtivo setOn:lemb.ativo];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        lemb = [itens objectAtIndex:indexPath.row];
        
        [lemb deletarNotificacao];

        [sL removeLembreteIndex:lemb.index];
        [itens removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mostrarLembrete"]) {
        NSIndexPath *indexPath = [self.tb indexPathForSelectedRow];
        lemb = [itens objectAtIndex:indexPath.row];
        LembreteViewController *destViewController = segue.destinationViewController;
        destViewController.lemb = lemb;
        destViewController.index = (int)indexPath.row;
    }
}

#pragma mark - Métodos

// Mudar estado da notificação
-(IBAction) mudarEstado:(id)sender{
    theSwitch = sender;
    lemb = [itens objectAtIndex:theSwitch.tag];
    [sL alterarEstado:theSwitch.on Index:lemb.index];
    if(theSwitch.on){
        [lemb criarNotificacao];
    }
    else {
        [lemb deletarNotificacao];
    }
}

@end
