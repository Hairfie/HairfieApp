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


- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_timeTable == nil)
        _timeTable = [[Timetable alloc] initEmpty];
    
 
    [self allDatesInWeekContainingDate];
    _doneBttn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}


-(void)allDatesInWeekContainingDate {
   
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];

    [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:language]];
    weekDays = [dateFormatter weekdaySymbols];
    
    NSUInteger firstWeekdayIndex = [[NSCalendar currentCalendar] firstWeekday];
    if (firstWeekdayIndex > 0)
    {
        weekDays = [[weekDays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekDays subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    }
    
    NSMutableArray *weekDayCapitalized = [[NSMutableArray alloc] init];
    for (NSString *day in weekDays)
    {
        
        NSString *capitalizedString = [day capitalizedString];
        [weekDayCapitalized addObject:capitalizedString];
    }
    weekDays = (NSArray*)weekDayCapitalized;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_timeTableView reloadData];
}

-(void)clearDay:(NSNotification*)notification
{
    ClaimTimetableCell *cell = notification.object;
    if (cell.tag == 0)
    {
        [_timeTable.monday removeAllObjects];
    }
    if (cell.tag == 1)
    {
       [_timeTable.monday removeAllObjects];
    }
    if (cell.tag == 2)
    {
       [_timeTable.monday removeAllObjects];
    }
    if (cell.tag == 3)
    {
       [_timeTable.monday removeAllObjects];
    }
    if (cell.tag == 4)
    {
        [_timeTable.monday removeAllObjects];
    }
    if (cell.tag == 5)
    {
       [_timeTable.monday removeAllObjects];
    }
    if (cell.tag == 6)
    {
        [_timeTable.monday removeAllObjects];
    }
    [_timeTableView reloadData];
  //  notification.object
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validateTimetable:(id)sender
{
    // TO DO enregistrer les horaires modifiés
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
    
    cell.day.text = [weekDays objectAtIndex:indexPath.row];
    
    
    
    if (indexPath.row == 0)
    {
        if ([_timeTable.monday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.monday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
            cell.tag = indexPath.row;
            //  [cell.deleteButton addTarget:self action:@selector(clearDay:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
            cell.deleteButton.hidden = YES;
        }
    }
    if (indexPath.row== 1){
        if ([_timeTable.tuesday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.tuesday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
        }  else{
            
            cell.deleteButton.hidden = YES;
            
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);         }
    }
    if (indexPath.row== 2){
        if ([_timeTable.wednesday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.wednesday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
        }        else{
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
            cell.deleteButton.hidden = YES;
        }
    }
    if (indexPath.row== 3){
        if ([_timeTable.thursday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.thursday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = indexPath.row;
        }        else {
            
            cell.deleteButton.hidden = YES;
            
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
        }
    }
    if (indexPath.row== 4){
        if ([_timeTable.friday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.friday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = indexPath.row;
        }        else {
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
            cell.deleteButton.hidden = YES;
            
        }
    }
    if (indexPath.row== 5){
        if ([_timeTable.saturday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.saturday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = indexPath.row;
        }
        else {
            cell.deleteButton.hidden = YES;
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
        }
    }
    if (indexPath.row == 6){
        if ([_timeTable.sunday count] != 0)
        {
            NSString *display = @"";
            for (TimeWindow *tm in _timeTable.sunday) {
                if ([display isEqualToString:@""]){
                    display = [tm timeWindowFormatted];
                } else {
                    display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
                }
            }
            cell.timewindow.text = display;
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = indexPath.row;
        }
        else{
            
            
            cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
            cell.deleteButton.hidden = YES;
            
        }
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
