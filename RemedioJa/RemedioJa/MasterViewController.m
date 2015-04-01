//
//  MasterViewController.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MasterViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "Farmacia.h"

@interface MasterViewController ()

@end

@implementation MasterViewController{
    NSMutableArray *remedios;
    UIActivityIndicatorView *spinner;
}
@synthesize pesquisa;
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadSite:(NSString*)termo{
    NSURL *site = [NSURL URLWithString:[NSString stringWithFormat:@"http://consultaremedios.com.br/busca?termo=%@", termo]];
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
            // Apresentacao
            res = [[elem searchWithXPathQuery:RemQueryAp]objectAtIndex:0];
            itemR.apresentacao = [[res firstChild] content];
            // Composto
            res = [[elem searchWithXPathQuery:RemQueryComp]objectAtIndex:0];
            itemR.composto = [[res firstChild] content];
            // Imagem
            res = [[elem searchWithXPathQuery:RemQueryImg]objectAtIndex:0];
            NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[res objectForKey:@"src"]]]], 1.0);
            if ([[res objectForKey:@"src"] isEqualToString:@"http://images.consultaremedios.com.br/160x160/anvisa"] || (imgData.length) == 10607) {
                itemR.imagem = [UIImage imageNamed:@"noImg"];
            }
            else{
                itemR.imagem = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[res objectForKey:@"src"]]]];
            }
            
            //NSLog(@"Remedio: %@, %@, %@, %@", itemR.nomeRemedio, [res objectForKey:@"src"], itemR.apresentacao, itemR.composto);
            
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
                
                //NSLog(@"Farmacia: %@, %@, %@, %.2f", itemF.nomeFarmacia, itemF.imagem, itemF.url, itemF.preco);
                [farmacias addObject:itemF];
            }
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"preco" ascending:YES];
            NSArray *sa = [NSArray arrayWithObject:sd];
            NSArray *farmSort = [farmacias sortedArrayUsingDescriptors:sa];
            itemR.farmacias = farmSort;
            [farmacias removeAllObjects];
            [remedios addObject:itemR];
        }
        else{
            //NSLog(@"NULL");
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pesquisa setDelegate:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Remedio *objRemedio = remedios[indexPath.row];
        [[segue destinationViewController] setItemR:objRemedio];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([pesquisa.text isEqualToString:@""]) {
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        return 0;
//    }
//    else{
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.textColor = [UIColor blackColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        // Return the number of sections.
//        if ([remedios count] != 0) {
//            messageLabel.text = @"";
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            return 1;
//            
//        } else {
//            messageLabel.text = @"Nenhum remédio encontrado";
//            // Display a message when the table is empty
//            self.tableView.backgroundView = messageLabel;
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        }
//        
//        return 0;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return remedios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Remedio *objR = remedios[indexPath.row];
    Farmacia *objF = objR.farmacias[0];
    [cell.nome setText:objR.nomeRemedio];
    [cell.ap setText:objR.apresentacao];
    [cell.preco setText:[NSString stringWithFormat:@"R$ %.2f", objF.preco]];
    [cell.img setImage:objR.imagem];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - Search bar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    if (![self conectado]) {
        UIAlertView *alertaNet = [[UIAlertView alloc] initWithTitle:@"Aviso!" message:@"Sem conexão com a internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertaNet show];
    }
    else{
        [remedios removeAllObjects];
        [self.tableView reloadData];
        
        spinner = [[UIActivityIndicatorView alloc]
                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(self.view.bounds.size.width /2, self.view.bounds.size.height / 2 - 45);
        spinner.transform = CGAffineTransformMakeScale(2.0, 2.0);
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        // how we stop refresh from freezing the main UI thread
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            [self loadSite:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
            
            // do any UI stuff on the main UI thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [self.tableView reloadData];
            });
        });
        
        [searchBar resignFirstResponder];
    }
}

-(BOOL)conectado{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus net = [reach currentReachabilityStatus];
    return (net != NotReachable);
}

@end
