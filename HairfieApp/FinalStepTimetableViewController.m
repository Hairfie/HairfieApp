//
//  FinalStepTimetableViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepTimetableViewController.h"
#import "FinalStepClaimDayViewController.h"

@interface FinalStepTimetableViewController ()

@end

@implementation FinalStepTimetableViewController
{
    NSString *dayPicked;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mondayButton.layer.cornerRadius = 5;
    _mondayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _mondayButton.layer.borderWidth = 1;

    _tuesdayButton.layer.cornerRadius = 5;
    _tuesdayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _tuesdayButton.layer.borderWidth = 1;
    
    _wednesdayButton.layer.cornerRadius = 5;
    _wednesdayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _wednesdayButton.layer.borderWidth = 1;
    
    _thursdayButton.layer.cornerRadius = 5;
    _thursdayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _thursdayButton.layer.borderWidth = 1;
    
    _fridayButton.layer.cornerRadius = 5;
    _fridayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _fridayButton.layer.borderWidth = 1;
    
    _saturdayButton.layer.cornerRadius = 5;
    _saturdayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _saturdayButton.layer.borderWidth = 1;
    
    _sundayButton.layer.cornerRadius = 5;
    _sundayButton.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _sundayButton.layer.borderWidth = 1;
    
    _doneBttn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}

-(IBAction)modifyDayTimeTable:(UIButton *)button{
    
    if ([button tag]==  0){
        dayPicked = @"Monday";
    }
    if ([button tag]==  1){
        dayPicked = @"Tuesday";
    }
    if ([button tag]==  2){
        dayPicked = @"Wednesday";
    }
    if ([button tag]==  3){
        dayPicked = @"Thursday";
    }
    if ([button tag]==  4){
        dayPicked = @"Friday";
    }
    if ([button tag]==  5){
        dayPicked = @"Saturday";
    }
    if ([button tag]==  6){
        dayPicked = @"Sunday";
    }
    [self performSegueWithIdentifier:@"claimWeekDay" sender:self];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validateTimetable:(id)sender
{
    // TO DO enregistrer les horaires modifiés
    
    [self goBack:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimWeekDay"])
    {
        
        FinalStepClaimDayViewController *claimDay = [segue destinationViewController];
        claimDay.headerString = dayPicked;
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
