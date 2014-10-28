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
#import "Week.h"
#import "Day.h"

@interface FinalStepTimetableViewController ()

@end

@implementation FinalStepTimetableViewController
{
    Day *dayPicked;
    NSArray *weekDays;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_timeTable == nil)
        _timeTable = [[Timetable alloc] initEmpty];
    
 
    weekDays = [[[Week alloc] init] weekdays];
    _doneBttn.layer.cornerRadius = 5;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearDay:)
                                                 name:@"clearDay"
                                               object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_timeTableView reloadData];
}

-(void)clearDay:(NSNotification*)notification
{
    ClaimTimetableCell *cell = notification.object;
    [_timeTable clearDayInteger:cell.tag];
    [_timeTableView reloadData];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validateTimetable:(id)sender
{
     FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
   
    
    if (finalStep.businessToManage != nil)
        finalStep.businessToManage.timetable = _timeTable;
    else
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
    dayPicked = [weekDays objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"addTimeWindow" sender:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"claimTimetableCell";
    ClaimTimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClaimTimetableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Day *currentDay = [weekDays objectAtIndex:indexPath.row];
    cell.day.text = currentDay.name;
    
    NSArray *currentTimeWindows = [_timeTable performSelector:currentDay.selector];
    
    if ([currentTimeWindows count] != 0) {
        NSString *display = @"";
        for (TimeWindow *tm in currentTimeWindows) {
            if ([display isEqualToString:@""]){
                display = [tm timeWindowFormatted];
            } else {
                display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
            }
        }
        cell.timewindow.text = display;
        cell.deleteButton.hidden = NO;
        cell.tag = indexPath.row;
    } else {
        cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
        cell.deleteButton.hidden = YES;
    }
    
    cell.tag = indexPath.row;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addTimeWindow"])
    {
        FinalStepClaimDayViewController *claimDay = [segue destinationViewController];
        claimDay.dayPicked = dayPicked;
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
