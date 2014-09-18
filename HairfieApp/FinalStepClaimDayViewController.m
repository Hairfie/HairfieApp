//
//  FinalStepClaimDayViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepClaimDayViewController.h"

@interface FinalStepClaimDayViewController ()

@end



@implementation FinalStepClaimDayViewController


@synthesize headerString;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"title %@", headerString);
    _headerTitle.text = headerString;

    
    _openingTime.layer.cornerRadius =5;
    _openingTime.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _openingTime.layer.borderWidth = 1;

    
    _closingTime.layer.cornerRadius =5;
    _closingTime.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _closingTime.layer.borderWidth = 1;


     _doneBttn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
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
