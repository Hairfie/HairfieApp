//
//  FinalStepTimetableViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepTimetableViewController.h"
#import "FinalStepClaimDayViewController.h"
#import "FinalStepViewController.h"

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
    
    _timeTable = [[Timetable alloc] initEmpty];
    
    
    
    
    
    _doneBttn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}



-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validateTimetable:(id)sender
{
    // TO DO enregistrer les horaires modifiés
     FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    
    
    [self goBack:self];
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
