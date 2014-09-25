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
#import "ClaimTimetableCell.h"
#import "TimeWindow.h"

@interface FinalStepTimetableViewController ()

@end

@implementation FinalStepTimetableViewController
{
    NSString *dayPicked;
    NSArray *weekDays;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeTable = [[Timetable alloc] initEmpty];
    
    weekDays = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    
    
    
    _doneBttn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{

        [_timeTableView reloadData];
    
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validateTimetable:(id)sender
{
    // TO DO enregistrer les horaires modifiés
     FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    finalStep.claim.timetable = _timeTable;
    
    [self goBack:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"claimTimetableCell";
    ClaimTimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClaimTimetableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.day.text = [weekDays objectAtIndex:indexPath.row];
    
    TimeWindow *timeWindow = [[TimeWindow  alloc]init];

    

    if (indexPath.row== 0){
        if ([_timeTable.monday count] != 0 ){
            timeWindow = [_timeTable.monday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"Set a time window";
    }
    if (indexPath.row== 1){
        if ([_timeTable.tuesday count] != 0 ){
            timeWindow = [_timeTable.tuesday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"Set a time window";
    }
    if (indexPath.row== 2){
        if ([_timeTable.wednesday count] != 0 ){
            timeWindow = [_timeTable.wednesday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"Set a time window";
    }
    if (indexPath.row== 3){
        if ([_timeTable.thursday count] != 0 )
        {
            timeWindow = [_timeTable.thursday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"Set a time window";
    }
    if (indexPath.row== 4){
        if ([_timeTable.friday count] != 0 ){
            timeWindow = [_timeTable.friday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"Set a time window";
    }
    if (indexPath.row== 5){
        if ([_timeTable.saturday count] != 0 ){
            timeWindow = [_timeTable.saturday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"No time window set";
    }
    if (indexPath.row== 6){
        if ([_timeTable.sunday count] != 0 ){
            timeWindow = [_timeTable.sunday objectAtIndex:0];
            cell.timewindow.text = [timeWindow timeWindowFormatted];
        }
        else
            cell.timewindow.text = @"Set a time window";
    }
    
    
    return cell;
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
