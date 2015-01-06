//
//  BusinessClaimExistingViewController.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 05/01/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//


#import "BusinessClaimExistingViewController.h"

#import "FinalStepViewController.h"
#import "Business.h"

@interface BusinessClaimExistingViewController ()

@end

@implementation BusinessClaimExistingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.headerTitleLabel.text = self.business.name;

    self.headerSubmitButton.layer.cornerRadius = 5;
    [self.headerSubmitButton setTitle:NSLocalizedStringFromTable(@"Claim", @"BusinessClaimExisting", nil)
                             forState:UIControlStateNormal];
    if(self.business.owner != nil) {
        [self.headerSubmitButton setHidden:YES];
        [self.webView setHidden:YES];
    } else {
        [self.alreadyClaimedLabel setHidden:YES];
        
//        [self.webView loadHTMLString:@"<html><body style=\"background-color:black;\"></body></html>" baseURL:nil];

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Claim" ofType:@"html"]]];
        [self.webView loadRequest:urlRequest];
    }
    
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)claim:(id)sender {
    [self.business claimWithSuccess:^(NSArray *result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
      //  [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"editClaimedBusiness" sender:self];
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editClaimedBusiness"]) {
        FinalStepViewController *finalStepVc = [segue destinationViewController];
        
        finalStepVc.isSegueFromBusinessDetail = NO;
        finalStepVc.businessToManage = self.business;
        
    }
        
}

@end
