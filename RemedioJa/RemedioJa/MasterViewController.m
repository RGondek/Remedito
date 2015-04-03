//
//  MasterViewController.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
@end

@implementation MasterViewController{
    NSMutableArray *remedios;
    UIActivityIndicatorView *spinner;
    NSUserDefaults *userDef;
    NSMutableArray *palavras;
    BOOL clicou;
}

@synthesize pesquisa;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pesquisa.delegate = self;
    userDef = [NSUserDefaults standardUserDefaults];
    palavras = [[NSMutableArray alloc] init];
    clicou = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Métodos

// Método para verificar conectividade com a internet
-(BOOL)conectado{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus net = [reach currentReachabilityStatus];
    return (net != NotReachable);
}

// ----- Busca remédios
- (void)loadSite:(NSString*)termo{
    NSURL *site = [NSURL URLWithString:[NSString stringWithFormat:@"http://consultaremedios.com.br/busca?termo=%@", termo]];
    NSData *siteHTML = [NSData dataWithContentsOfURL:site];
    TFHpple *siteParser = [TFHpple hppleWithHTMLData:siteHTML];
    
    // ----- Query Base (Acima de outras informações)
    NSString *queryBase = @"//ul[@class='container product-section clearfix']";
    
    // ----- Query Remédios
    // Imagem = objectForKey:@"src"
    NSString *RemQueryImg = @"//li[@class='title clearfix']/figure[@class='medicine-thumb']/img";
    // Nome = firstChild > content
    NSString *RemQueryNome = @"//li[@class='title clearfix']/div[@class='medicine-data']/h3/a";
    // Apresentação = firstChild > content
    NSString *RemQueryAp = @"//li[@class='title clearfix']/div[@class='medicine-data']/div[@class='medicine-info clearfix']/div[@class='pull-left']/strong";
    // Composto = firstChild > content
    NSString *RemQueryComp = @"//li[@class='title clearfix']/div[@class='medicine-data']/p[@class='medicine-active-ingredient clearfix']/a";
    
    // ----- Query Farmácias Base
    NSString *queryFarmBase = @"//li[@class='item']";
    
    // ----- Query Farmácias
    // URL = objectForKey:@"href" | Imagem = firstChild > objectForKey:@"src" | Nome = firstChild > objectForKey:@"alt"
    NSString *FarmQueryUrl_Img_Nome = @"//div[@class='item-pharmacy']/div[@class='item-pharmacy-logo']/a";
    // Preço = firstChild > content
    NSString *FarmQueryPreco = @"//div[@class='item-price']/a/p";
    
    remedios = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *farmacias = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *resBase = [siteParser searchWithXPathQuery:queryBase];
    // Verifica resultados Base
    for (TFHppleElement *elem in resBase) {
        Remedio *itemR = [[Remedio alloc] init];
        // Busca os remédios dentro da Query Base
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
            
            // Busca as farmácias a partir da Query Base
            NSArray *resArrayFarm = [elem searchWithXPathQuery:queryFarmBase];
            TFHppleElement *resFarm;
            // Verifica resultados da busca
            for (TFHppleElement *farm in resArrayFarm) {
                Farmacia *itemF = [[Farmacia alloc] init];
                
                resFarm = [[farm searchWithXPathQuery:FarmQueryUrl_Img_Nome] objectAtIndex:0];
                itemF.url = [resFarm objectForKey:@"href"];
                itemF.imagem = [[resFarm firstChild] objectForKey:@"src"];
                itemF.nomeFarmacia = [[resFarm firstChild] objectForKey:@"alt"];
                
                resFarm = [[farm searchWithXPathQuery:FarmQueryPreco]objectAtIndex:0];
                
                itemF.preco = [[[[[resFarm firstChild] content] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue];
                [farmacias addObject:itemF];
            }
            
            // Ordena o vetor de farmácias pelo preço
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"preco" ascending:YES];
            NSArray *sa = [NSArray arrayWithObject:sd];
            NSArray *farmSort = [farmacias sortedArrayUsingDescriptors:sa];
            
            itemR.farmacias = farmSort;
            [farmacias removeAllObjects];
            [remedios addObject:itemR];
        }
    }
    [self.tableView reloadData];
    
    // Oculta o Network Indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - Segues

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Clicar na busca recente
    if (clicou) {
        pesquisa.text = palavras[indexPath.row];
        [self searchBarSearchButtonClicked:pesquisa];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Segue para tela de detalhes
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Remedio *objRemedio = remedios[indexPath.row];
        [[segue destinationViewController] setItemR:objRemedio];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Verifica se vai mostrar as buscas recentes ou os resultados da busca atual
    if (clicou) {
        palavras  = [NSMutableArray arrayWithArray:[userDef arrayForKey:@"salvando"]];
        return palavras.count;
    }
    else { return remedios.count; }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    palavras  = [NSMutableArray arrayWithArray:[userDef arrayForKey:@"salvando"]];
    if (clicou) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Celula"];

        [cell.textLabel setText:[palavras objectAtIndex:indexPath.row]];
        [cell setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        return cell;
    }
    else {
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        Remedio *objR = remedios[indexPath.row];
        [cell.nome setText:objR.nomeRemedio];
        [cell.ap setText:objR.apresentacao];
        [cell.img setImage:objR.imagem];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (clicou) { return 40; }
    else { return 70; }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - Search bar

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    clicou = YES;
    [self.tableView reloadData];
    
    return YES;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    clicou = NO;
    [searchBar setUserInteractionEnabled:NO];
    
    // Verifica conexão com internet
    if (![self conectado]) {
        UIAlertView *alertaNet = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Aviso", nil) message:NSLocalizedString(@"Sem conexão com a internet", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertaNet show];
        [searchBar setUserInteractionEnabled:YES];
    }
    
    // Regex para termos inválidos
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[ A-Z0-9a-z._%+-]{2,100}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:pesquisa.text options:0 range:NSMakeRange(0, [pesquisa.text length])];
    
    if (![pesquisa.text isEqual: @""]) {
        if (!match) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erro", nil) message:NSLocalizedString(@"Termo inválido", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [searchBar setUserInteractionEnabled:YES];
        }
        
        else {
            // Mostra Network indicator
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [remedios removeAllObjects];
            [self.tableView reloadData];
            
            // Mostra Activity indicator
            spinner = [[UIActivityIndicatorView alloc]
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = CGPointMake(self.view.bounds.size.width /2, self.view.bounds.size.height / 2 + 15);
            spinner.transform = CGAffineTransformMakeScale(2.0, 2.0);
            spinner.hidesWhenStopped = YES;
            [self.view addSubview:spinner];
            [spinner startAnimating];
            
            // Download das informações de modo assíncrono
            dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
            dispatch_async(downloadQueue, ^{
                [self loadSite:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner stopAnimating];
                    [self.tableView reloadData];
                    if ([remedios count] == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remédio não encontrado", nil) message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    else {
                        palavras  = [NSMutableArray arrayWithArray:[userDef arrayForKey:@"salvando"]];
                        if(![palavras containsObject:pesquisa.text]){
                            [palavras addObject:searchBar.text];
                            [userDef setObject:palavras forKey:@"salvando"];
                            [userDef synchronize];
                        }
                    }
                    [searchBar setUserInteractionEnabled:YES];

                });
            });
            [searchBar resignFirstResponder];
        }
    }
}

@end
