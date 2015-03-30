//
//  ListaViewController.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListaViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>

@property NSArray *matchingItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) id<MapViewDelegate> delegate;
- (IBAction)voltar:(id)sender;
- (IBAction)tracarRota:(id)sender;

@end
