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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//}

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
    NSLog(@"%li",(long)indexPath.row);
    NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
    // Get list of local notifications
    lemb = [sL.lembretes objectAtIndex:indexPath.row];
//    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    UILocalNotification *localNotification = [localNotifications objectAtIndex:indexPath.row];
    
    NSDateFormatter *dtForm = [[NSDateFormatter alloc] init];
    [dtForm setDateFormat:@"HH:mm"];
    
    
    // Display notification info
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
    if(theSwitch.on){
        NSLog (@"foi?");
    }
    else {
        NSLog(@"foi mas ta desligado :( " );
        
    }
}

//-(void)mudarEstado:(id)sender{
//   
//    UISwitch *btn = sender;
//    NSIndexPath *ind = [self getButtonIndexPath:sender];
//    lemb = [sL.lembretes objectAtIndex:ind.row];
//    lemb.ativo = btn.isOn;
//}

-(NSIndexPath *) getButtonIndexPath:(UISwitch*)s{
    CGRect frame = [s convertRect:s.bounds toView:tb];
    return [tb indexPathForRowAtPoint:frame.origin];
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
