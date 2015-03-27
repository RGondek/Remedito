//
//  MasterViewController.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "TableViewCell.h"
#import "Remedio.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface MasterViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *pesquisa;

-(BOOL) conectado;

@end

