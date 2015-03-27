//
//  WebViewController.h
//  RemedioJa
//
//  Created by Rubens Gondek on 3/26/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSURL *url;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end
