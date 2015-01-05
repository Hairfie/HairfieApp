//
//  BusinessClaimExistingViewController.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 05/01/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "BusinessClaimExistingViewController.h"
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
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)claim:(id)sender {
    [self.business claimWithSuccess:^(NSArray *results) {
        NSLog(@"results : %@", results);
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}

-(void)claimSubmitted {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
