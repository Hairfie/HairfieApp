//
//  ClaimBusinessWebViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 2/3/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ClaimBusinessWebViewController.h"

@interface ClaimBusinessWebViewController ()

@end

@implementation ClaimBusinessWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Claim" ofType:@"html"]]];
    [self.webView loadRequest:urlRequest];
    self.claimBttn.layer.cornerRadius = 5;
    self.claimBttn.layer.masksToBounds = YES;
    self.headerTitleLabel.text = NSLocalizedStringFromTable(@"Claim your business", @"Claim", nil);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
