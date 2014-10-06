//
//  SecondStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SecondStepViewController.h"
#import "SecondStepSalonPhoneViewController.h"
#import "ThirdStepViewController.h"

@interface SecondStepViewController ()
{
    BOOL man;
    BOOL woman;
    BOOL kids;
    BOOL isOwner;
    NSString *authorRole;
}


@end

@implementation SecondStepViewController


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"2ND STEP CLAIM %@", _claim);
   
    _salonBttn.layer.cornerRadius =5;
    _salonBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _salonBttn.layer.borderWidth = 1;
   
    man = YES;
    woman = YES;
    kids = YES;
    
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

-(IBAction)segmentedControlValueChanged:(id)sender
{
    if (_jobType.selectedSegmentIndex == 0)
    {
        isOwner = YES;
        authorRole = @"manager";
        NSLog(@"Manager");
    }
    else
    {
        isOwner = NO;
        authorRole = @"employee";
        NSLog(@"Employé");
    }
}


-(IBAction)claimBusinessLocation:(id)sender
{
    if (![_salonTextField.text isEqualToString:@""] && ![_phoneTextField.text isEqualToString:@""]) {
        NSLog(@"CLAIM CLAIM CLAIM");
        _claim.name = _salonTextField.text;
        _claim.phoneNumber = _phoneTextField.text;
        _claim.men = man;
        _claim.women = woman;
        _claim.children = kids;
        _claim.authorRole = authorRole;
        
        void (^loadErrorBlock)(NSError *) = ^(NSError *error){
            NSLog(@"Error : %@", error.description);
        };
        void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
            //_claim.id = [results objectForKey:@"id"];
           [self performSegueWithIdentifier:@"claimBusinessLocation" sender:self];
        };
        
        [_claim claimWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    
    }
    else
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill in your business' name and phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }

}
    
        
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimPhone"])
    {
        
        SecondStepSalonPhoneViewController *phone = [segue destinationViewController];
     
        phone.isSalon= NO;
        phone.isFinalStep = NO;
        phone.textFieldFromSegue = _phoneTextField.text;
        phone.headerTitle = NSLocalizedStringFromTable(@"Phone", @"Claim", nil);
        phone.textFieldPlaceHolder = _phoneTextField.placeholder;
        if (_isPhoneSet == YES)
        {
            phone.isExisting = YES;
        }
    }
    if ([segue.identifier isEqualToString:@"claimSalon"])
    {
        SecondStepSalonPhoneViewController *salon = [segue destinationViewController];
        
        salon.headerTitle = NSLocalizedStringFromTable(@"Salon's Name", @"Claim", nil);
         salon.isFinalStep = NO;
        salon.isSalon = YES;
    
        salon.textFieldPlaceHolder = _salonTextField.placeholder;
        salon.textFieldFromSegue = _salonTextField.text;
        if (_isSalonSet == YES)
        {
            salon.isExisting = YES;
        }
    }
    if ([segue.identifier isEqualToString:@"claimBusinessLocation"])
    {
        ThirdStepViewController *thirdStep = [segue destinationViewController];
        thirdStep.claim = [[BusinessClaim alloc] init];
        thirdStep.claim = _claim;
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
