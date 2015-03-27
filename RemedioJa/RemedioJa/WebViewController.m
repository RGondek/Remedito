//
//  WebViewController.m
//  RemedioJa
//
//  Created by Rubens Gondek on 3/26/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize progress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    progress.progress = webView.contentScaleFactor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
