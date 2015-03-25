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

@property NSMutableArray *objects;
@end

@implementation MasterViewController{
    NSString *termo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadSite{
    termo = @"Cataflam";
    NSURL *site = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.consultaremedios.com.br/busca?termo=%@", termo]];
    NSData *siteHTML = [NSData dataWithContentsOfURL:site];
    
    TFHpple *siteParser = [TFHpple hppleWithHTMLData:siteHTML];
    
    NSString *queryBase = @"//div[@class='container product-section clearfix']";
    
    // Query Remédios
    NSString *RemQueryImg = @"/div[@class='title clearfix']/figure[@class='medicine-thumb']/img"; // Src
    NSString *RemQueryNome = @"/div[@class='title clearfix']/div[@class='medicine-data']/h3/a"; // FirstChild
    NSString *RemQueryAp = @"/div[@class='title clearfix']/div[@class='medicine-info clearfix']/div[@class='pull-left']/strong"; // FirstChild
    NSString *RemQueryComp = @"/div[@class='title clearfix']/p[@class='medicine-active-ingredient clearfix']/a"; // FirstChild
    
    // Query Farmácias
    NSString *FarmQueryUrl_Img_Nome = @"/li[@class='item']/div[@class='item-pharmacy']/div[@class='item-pharmacy-logo']/a"; // Img: /img@src | URL: href | Nome: /img@alt
    NSString *FarmQueryPreco = @"/li[@class='item']/div[@class='item-price']/a/p"; // FirstChild
    
    
    NSArray *resBase = [siteParser searchWithXPathQuery:queryBase];
    
    
    NSMutableArray *remedios = [[NSMutableArray alloc] init];
    for (TFHppleElement *elem in resBase) {
        Remedio *item = [[Remedio alloc] init];
        [remedios addObject:item];
        
        item.nomeRemedio = [elem objectForKey:@"href"];
    }
//    int i = 0;
//    for (TFHppleElement *elem2 in results2) {
//        
//        Tutorial *item = [[Tutorial alloc] init];
//        item = [newItems objectAtIndex:i];
//        
//        item.title = [elem2 objectForKey:@"title"];
//        item.image = [NSString stringWithFormat:@"http://www.bifarma.com.br%@", [elem2 objectForKey:@"src"]];
//        i++;
//    }
//    
//    objs = newItems;
//    [self.tableView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
