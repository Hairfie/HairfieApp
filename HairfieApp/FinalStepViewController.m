//
//  FinalStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepViewController.h"
#import "SecondStepSalonPhoneViewController.h"

@interface FinalStepViewController ()

@end

@implementation FinalStepViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(IBAction)modifyPhoneNumber:(id)sender
{
    [self performSegueWithIdentifier:@"claimPhone" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"claimPhone"])
    {
        
        SecondStepSalonPhoneViewController *phone = [segue destinationViewController];
        
        if (![_phoneBttn.titleLabel.text isEqualToString:@"Numéro de téléphone"]) {
            phone.textFieldFromSegue = _phoneBttn.titleLabel.text;
        }
        phone.headerTitle = @"Téléphone";
        phone.textFieldPlaceHolder = @"Numéro de téléphone";
    }
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
