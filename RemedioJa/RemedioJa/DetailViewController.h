//
//  DetailViewController.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/25/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgRemedio;
@property (weak, nonatomic) IBOutlet UILabel *nomeRemedio;
@property (weak, nonatomic) IBOutlet UILabel *apRemedio;
@property (weak, nonatomic) IBOutlet UILabel *compRemedio;
@property (weak, nonatomic) IBOutlet UILabel *pDeRemedio;
@property (weak, nonatomic) IBOutlet UILabel *pAteRemedio;

@property (weak, nonatomic) IBOutlet UITableView *tableViewF;

@end

