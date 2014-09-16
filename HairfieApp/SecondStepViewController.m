//
//  SecondStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SecondStepViewController.h"
#import "SecondStepSalonPhoneViewController.h"

@interface SecondStepViewController ()
{
    BOOL man;
    BOOL woman;
    BOOL kids;
}


@end

@implementation SecondStepViewController


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _salonBttn.layer.cornerRadius =5;
    _salonBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _salonBttn.layer.borderWidth = 1;
   
    man = NO;
    woman = NO;
    kids = NO;
    
    _phoneBttn.layer.cornerRadius =5;
    _phoneBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _phoneBttn.layer.borderWidth = 1;
    _nextBttn.layer.cornerRadius = 5;
    
    [_workType setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greyHairfie]} forState:UIControlStateNormal];
    _workType.layer.borderColor = [UIColor greyHairfie].CGColor;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)claimDetails:(id)sender
{
    if (sender == _phoneBttn)
        [self performSegueWithIdentifier:@"claimPhone" sender:self];
    if (sender == _salonBttn)
        [self performSegueWithIdentifier:@"claimSalon" sender:self];
}



-(IBAction)checkMan:(id)sender
{
    if (man == NO)
    {

        [_manCutCheckBox setImage:[UIImage imageNamed:@"checkbox-true.png"]];
        man = YES;
    }
    else
    {
        [_manCutCheckBox setImage:[UIImage imageNamed:@"checkbox-false.png"]];
        man = NO;
    }
    
}
-(IBAction)checkWoman:(id)sender
{

    if (woman == NO)
    {
        [_womanCutCheckBox setImage:[UIImage imageNamed:@"checkbox-true.png"]];
        woman = YES;
    }
    else
    {
        [_womanCutCheckBox setImage:[UIImage imageNamed:@"checkbox-false.png"]];
        woman = NO;
    }

}
-(IBAction)checkKids:(id)sender
{
    if (kids == NO)
    {
        [_kidsCutCheckBox setImage:[UIImage imageNamed:@"checkbox-true.png"]];
        kids = YES;
    }
    else
    {
        [_kidsCutCheckBox setImage:[UIImage imageNamed:@"checkbox-false.png"]];
        kids = NO;
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimPhone"])
    {
        SecondStepSalonPhoneViewController *phone = [segue destinationViewController];
     
        phone.headerTitle = @"Téléphone";
        phone.textFieldPlaceHolder = @"Numéro de téléphone";
    }
    
    if ([segue.identifier isEqualToString:@"claimSalon"])
    {
        SecondStepSalonPhoneViewController *salon = [segue destinationViewController];
        
        salon.headerTitle = @"Nom du salon";
        salon.textFieldPlaceHolder = @"Nom du salon";
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
