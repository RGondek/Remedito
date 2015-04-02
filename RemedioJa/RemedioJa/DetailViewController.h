//
//  DetailViewController.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Remedio.h"
#import "Farmacia.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Remedio *itemR;

@property (strong, nonatomic) NSURL *urlSite;
@property (weak, nonatomic) IBOutlet UIImageView *imgRemedio;
@property (weak, nonatomic) IBOutlet UILabel *nomeRemedio;
@property (weak, nonatomic) IBOutlet UILabel *apRemedio;
@property (weak, nonatomic) IBOutlet UILabel *compRemedio;
@property (weak, nonatomic) IBOutlet UILabel *pDeRemedio;
@property (weak, nonatomic) IBOutlet UILabel *pAteRemedio;

@property (weak, nonatomic) IBOutlet UITableView *tableViewF;

@end

