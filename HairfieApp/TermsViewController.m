//
//  TermsViewController.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 07/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TermsViewController.h"

@implementation TermsViewController

-(void)viewDidLoad {

    NSURL *url = [NSURL URLWithString:TERMS_URL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
