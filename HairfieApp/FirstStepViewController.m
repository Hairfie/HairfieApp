//
//  FirstStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FirstStepViewController.h"

@interface FirstStepViewController ()

@end

@implementation FirstStepViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _salonBttn.layer.cornerRadius =5;
    _salonBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _salonBttn.layer.borderWidth = 1;
    
    _homeBttn.layer.cornerRadius =5;
    _homeBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _homeBttn.layer.borderWidth = 1;
  
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
