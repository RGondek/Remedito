//
//  HorariosViewController.h
//  RemedioJa
//
//  Created by Ricardo Hochman on 26/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorariosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UISwitch    *theSwitch;
}

@property (weak, nonatomic) IBOutlet UITableView *tb;

-(IBAction)mudarEstado:(id)sender;

@end
