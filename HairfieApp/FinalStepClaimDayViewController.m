//
//  FinalStepClaimDayViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepClaimDayViewController.h"
#import "FinalStepTimetableViewController.h"
#import "TimeWindow.h"
#import "Timetable.h"

@interface FinalStepClaimDayViewController ()

@end



@implementation FinalStepClaimDayViewController
{
    NSArray *halfHour;
    NSDictionary *timeTable;
}

@synthesize headerString;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.topBarView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];

    NSLog(@"Daypicked : %@", _dayPicked.name);
    _doneBttn.layer.cornerRadius = 5;
    timeTable = [[NSDictionary alloc] init];
    halfHour = [[NSArray alloc] initWithObjects:@"00",@"30", nil];
    
    [_dayPickerView selectRow:0 inComponent:0 animated:NO];
    [_openingTimePicker selectRow:9 inComponent:0 animated:NO];
    [_openingTimePicker selectRow:0 inComponent:1 animated:NO];
    [_closingTimePicker selectRow:18 inComponent:0 animated:NO];
    [_closingTimePicker selectRow:1 inComponent:1 animated:NO];
    [_openingTimePicker reloadAllComponents];
    [_closingTimePicker reloadAllComponents];
    
    _openingTimeView.layer.cornerRadius = 5;
    _openingTimeView.layer.masksToBounds = YES;
    _openingTimeView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _openingTimeView.layer.borderWidth = 1;
    _closingTimeView.layer.cornerRadius = 5;
    _closingTimeView.layer.masksToBounds = YES;
    _closingTimeView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _closingTimeView.layer.borderWidth = 1;
 
    
    _closingTime = @"18:30";
    _openingTime = @"9:00";
    
}




- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return 24;
    else
        return 2;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    
    
    tView = [[UILabel alloc] init];
    [tView setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:17]];
    [tView setTextAlignment:NSTextAlignmentCenter];
    
    
    if (component == 0)
        tView.text=[NSString stringWithFormat:@"%ld", row];
    else
        tView.text = [halfHour objectAtIndex:row];
    
    
    return tView;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
   
    if (pickerView == _openingTimePicker)
    {
        NSString *minutes = [halfHour objectAtIndex:[pickerView selectedRowInComponent:1]];
        _openingTime = [NSString stringWithFormat:@"%zd:%@", [pickerView selectedRowInComponent:0], minutes];
        NSLog(@"Opening Time %@", _openingTime);
    }
    if (pickerView == _closingTimePicker)
    {
        NSString *minutes = [halfHour objectAtIndex:[pickerView selectedRowInComponent:1]];
        _closingTime = [NSString stringWithFormat:@"%zd:%@", [pickerView selectedRowInComponent:0], minutes];
        NSLog(@"Closing Time %@", _closingTime);
    }
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)addTimeTable:(id)sender
{
    FinalStepTimetableViewController *claimTimeTable = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    TimeWindow *timeWindow = [[TimeWindow alloc] initWithStartTime:_openingTime endTime:_closingTime appointmentMode:nil];
    NSLog(@"Daypicked : %@", _dayPicked.name);
    [[claimTimeTable.timeTable performSelector:_dayPicked.selector] addObject:timeWindow];
    [_openingTimePicker reloadAllComponents];
    [_closingTimePicker reloadAllComponents];
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
