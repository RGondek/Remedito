//
//  MasterViewController.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Remedio.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "Farmacia.h"

@interface MasterViewController ()

@end

@implementation MasterViewController{
    NSString *termo;
    NSMutableArray *remedios;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadSite{
    termo = @"cataflam";
    NSURL *site = [NSURL URLWithString:[NSString stringWithFormat:@"http://consultaremedios.com.br/busca?termo=cataflam"]];
    NSData *siteHTML = [NSData dataWithContentsOfURL:site];
    
    TFHpple *siteParser = [TFHpple hppleWithHTMLData:siteHTML];
    
    NSString *queryBase = @"//ul[@class='container product-section clearfix']";
    
    // Query Remédios
    NSString *RemQueryImg = @"//li[@class='title clearfix']/figure[@class='medicine-thumb']/img"; // Src
    NSString *RemQueryNome = @"//li[@class='title clearfix']/div[@class='medicine-data']/h3/a"; // FirstChild
    NSString *RemQueryAp = @"//li[@class='title clearfix']/div[@class='medicine-data']/div[@class='medicine-info clearfix']/div[@class='pull-left']/strong"; // FirstChild
    NSString *RemQueryComp = @"//li[@class='title clearfix']/div[@class='medicine-data']/p[@class='medicine-active-ingredient clearfix']/a"; // FirstChild
    
    // Query Farmácias
    
    NSString *queryFarmBase = @"//li[@class='item']";
    
    NSString *FarmQueryUrl_Img_Nome = @"//div[@class='item-pharmacy']/div[@class='item-pharmacy-logo']/a"; // Img: /img@src | URL: href | Nome: /img@alt
    NSString *FarmQueryPreco = @"//div[@class='item-price']/a/p"; // FirstChild
    
    
    NSArray *resBase = [siteParser searchWithXPathQuery:queryBase];
    
    
    remedios = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *farmacias = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *elem in resBase) {
        Remedio *itemR = [[Remedio alloc] init];
        NSArray *resArray = [elem searchWithXPathQuery:RemQueryNome];
        TFHppleElement *res;
        if (resArray.count != 0) {
            // Nome
            res = resArray[0];
            itemR.nomeRemedio = [[res firstChild] content];
            // Imagem
            res = [[elem searchWithXPathQuery:RemQueryImg]objectAtIndex:0];
            itemR.imagem = [res objectForKey:@"src"];
            // Apresentacao
            res = [[elem searchWithXPathQuery:RemQueryAp]objectAtIndex:0];
            itemR.apresentacao = [[res firstChild] content];
            // Composto
            res = [[elem searchWithXPathQuery:RemQueryComp]objectAtIndex:0];
            itemR.composto = [[res firstChild] content];
            
            NSLog(@"Remedio: %@, %@, %@, %@", itemR.nomeRemedio, itemR.imagem, itemR.apresentacao, itemR.composto);
            
            NSArray *resArrayFarm = [elem searchWithXPathQuery:queryFarmBase];
            TFHppleElement *resFarm;
            for (TFHppleElement *farm in resArrayFarm) {
                Farmacia *itemF = [[Farmacia alloc] init];
                
                resFarm = [[farm searchWithXPathQuery:FarmQueryUrl_Img_Nome] objectAtIndex:0];
                itemF.url = [resFarm objectForKey:@"href"];
                itemF.imagem = [[resFarm firstChild] objectForKey:@"src"];
                itemF.nomeFarmacia = [[resFarm firstChild] objectForKey:@"alt"];
                
                resFarm = [[farm searchWithXPathQuery:FarmQueryPreco]objectAtIndex:0];
                
                itemF.preco = [[[[[resFarm firstChild] content] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue];
                
                NSLog(@"Farmacia: %@, %@, %@, %.2f", itemF.nomeFarmacia, itemF.imagem, itemF.url, itemF.preco);
                [farmacias addObject:itemF];
            }
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"preco" ascending:YES];
            NSArray *sa = [NSArray arrayWithObject:sd];
            NSArray *farmSort = [farmacias sortedArrayUsingDescriptors:sa];
            itemR.farmacias = farmSort;
            [remedios addObject:itemR];
        }
        else{
            NSLog(@"NULL");
        }
    }
//    
//    objs = newItems;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    [self loadSite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Remedio *objRemedio = remedios[indexPath.row];
        [[segue destinationViewController] setDetailItem:objRemedio];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return remedios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Remedio *objR = remedios[indexPath.row];
    cell.textLabel.text = objR.nomeRemedio;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

@end