//
//  ClaimAddPricesSalesViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimAddPricesSalesViewController.h"

@interface ClaimAddPricesSalesViewController ()

@end

@implementation ClaimAddPricesSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _priceDescriptionView.layer.cornerRadius = 5;
    _priceDescriptionView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _priceDescriptionView.layer.borderWidth = 1;
    
    _priceValueView.layer.cornerRadius = 5;
    _priceValueView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _priceValueView.layer.borderWidth = 1;
    
    _doneBttn.layer.cornerRadius = 5;
    _doneBttn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
