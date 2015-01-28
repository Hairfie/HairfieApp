//
//  HorairesViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HorairesViewController.h"
#import "HoraireTableViewCell.h"
#import "TimeWindow.h"
#import "Week.h"
#import "Day.h"

@interface HorairesViewController ()

@end

@implementation HorairesViewController {
    NSArray *weekdays;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
    weekdays = [[[Week alloc] init] weekdays];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"horaireCell";
    HoraireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HoraireTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Day *currentDay = [weekdays objectAtIndex:indexPath.row];
    NSArray *timeWindows = [self.timetable performSelector:currentDay.selector];
    NSString *dayOfWeek = currentDay.name;
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];

    for (TimeWindow *timeWindow in timeWindows) {
        [timeArray addObject:timeWindow.timeWindowFormatted];
    }

    cell.day.text = dayOfWeek;
    cell.time.text = [timeArray componentsJoinedByString:@" / "];
    
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
