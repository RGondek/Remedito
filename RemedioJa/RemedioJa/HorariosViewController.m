//
//  HorariosViewController.m
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "HorariosViewController.h"
#import "HorarioTableViewCell.h"
#import "SingletonLemb.h"
#import "Lembrete.h"
#import "LembreteViewController.h"

@interface HorariosViewController ()

@end

@implementation HorariosViewController{
    Lembrete *lemb;
    SingletonLemb *sL;
}

@synthesize tb;

- (void)viewDidLoad {
    [super viewDidLoad];
    sL = [SingletonLemb instance];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [tb reloadData];
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sL.lembretes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HorarioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    lemb = [sL.lembretes objectAtIndex:indexPath.row];
    
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

-(IBAction)mudarEstado:(id)sender{
    theSwitch = sender;
    NSLog(@"%lu", theSwitch.tag);
    lemb = [sL.lembretes objectAtIndex:theSwitch.tag];
    lemb.ativo = theSwitch.on;
    if(theSwitch.on){
        UILocalNotification *notificacao = [[UILocalNotification alloc] init];
        notificacao.fireDate = lemb.data;
        notificacao.alertBody = lemb.nome;
        notificacao.soundName = UILocalNotificationDefaultSoundName;
        notificacao.timeZone = [NSTimeZone defaultTimeZone];
        
        notificacao.repeatInterval = NSCalendarUnitHour;
        
        notificacao.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notificacao];
    }
    else {
        UILocalNotification *notificacao = [[UILocalNotification alloc] init];
        notificacao.fireDate = lemb.data;
        notificacao.alertBody = lemb.nome;
        notificacao.soundName = UILocalNotificationDefaultSoundName;
        notificacao.timeZone = [NSTimeZone defaultTimeZone];
        
        notificacao.repeatInterval = NSCalendarUnitHour;
        
        notificacao.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] cancelLocalNotification:notificacao];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mostrarLembrete"]) {
        NSIndexPath *indexPath = [self.tb indexPathForSelectedRow];
        lemb = [sL.lembretes objectAtIndex:indexPath.row];
        LembreteViewController *destViewController = segue.destinationViewController;
        destViewController.lemb = lemb;
        destViewController.index = (int)indexPath.row;
    }
}


@end
