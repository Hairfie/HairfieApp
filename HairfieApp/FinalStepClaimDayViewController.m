//
//  FinalStepClaimDayViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepClaimDayViewController.h"
#import "TimeTableView.h"

@interface FinalStepClaimDayViewController ()

@end



@implementation FinalStepClaimDayViewController
{
    NSArray *weekDays;
    NSArray *halfHour;
}

@synthesize headerString;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _doneBttn.layer.cornerRadius = 5;
    
     [_openingTimePicker selectRow:10 inComponent:0 animated:YES];
    [_openingTimePicker selectRow:0 inComponent:1 animated:YES];
    
     [_closingTimePicker selectRow:18 inComponent:0 animated:YES];
    [_closingTimePicker selectRow:0 inComponent:1 animated:YES];
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
    weekDays = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
     halfHour = [[NSArray alloc] initWithObjects:@"00",@"30", nil];
    
    
    
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    if (pickerView == _dayPickerView)
        return 1;
    else
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _dayPickerView)
        return weekDays.count;
    else if (pickerView == _openingTimePicker || pickerView == _closingTimePicker)
    {
        if (component == 0)
            return 24;
        else
            return 2;
    }
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
     UILabel* tView = (UILabel*)view;
    

    tView = [[UILabel alloc] init];
    [tView setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:17]];
    [tView setTextAlignment:NSTextAlignmentCenter];
    
   
    
    if (pickerView == _dayPickerView)
    {
        // Fill the label text here
    tView.text=[weekDays objectAtIndex:row];
   
    }
    if (pickerView == _openingTimePicker || pickerView == _closingTimePicker)
    {
        if (component == 0)
             tView.text=[NSString stringWithFormat:@"%ld", row];
        else
            tView.text = [halfHour objectAtIndex:row];
    }
   
    return tView;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
   
    if (pickerView == _dayPickerView)
        _dayPicked = [weekDays objectAtIndex:row];
    if (pickerView == _openingTimePicker)
    {

        NSString *minutes = [halfHour objectAtIndex:[pickerView selectedRowInComponent:1]];
        _openingTime = [NSString stringWithFormat:@"%ldh%@", [pickerView selectedRowInComponent:0], minutes];
        NSLog(@"Opening Time %@", _openingTime);
    }
    if (pickerView == _closingTimePicker)
    {
        
        NSString *minutes = [halfHour objectAtIndex:[pickerView selectedRowInComponent:1]];
        _closingTime = [NSString stringWithFormat:@"%ldh%@", [pickerView selectedRowInComponent:0], minutes];
        NSLog(@"Closing Time %@", _closingTime);
    }
    
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)addTimeTable:(id)sender
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"TimeTableView" owner:self options:nil];
    
    TimeTableView *timeTable = [subviewArray objectAtIndex:0];
    
   
    NSLog(@"ici");
    [timeTable settimeTableStringOpen:_openingTime andClose:_closingTime];
    [timeTable setDayForTimetable:_dayPicked];
    
    [self.view addSubview:timeTable];
    [self.view bringSubviewToFront:timeTable];
    
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
