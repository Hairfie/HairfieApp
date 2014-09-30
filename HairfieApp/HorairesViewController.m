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

@interface HorairesViewController ()

@end

@implementation HorairesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _tableViewHeight.constant = 7 * 65;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

    NSArray *timeWindows;
    NSString *dayOfWeek;
    
    switch (indexPath.row) {
        case 0:
            timeWindows = self.timetable.monday;
            dayOfWeek = NSLocalizedStringFromTable(@"Monday", @"Horaires", nil);
            break;
        case 1:
            timeWindows = self.timetable.tuesday;
            dayOfWeek = NSLocalizedStringFromTable(@"Tuesday", @"Horaires", nil);
            break;
        case 2:
            timeWindows = self.timetable.wednesday;
            dayOfWeek = NSLocalizedStringFromTable(@"Wednesday", @"Horaires", nil);
            break;
        case 3:
            timeWindows = self.timetable.thursday;
            dayOfWeek = NSLocalizedStringFromTable(@"Thursday", @"Horaires", nil);
            break;
        case 4:
            timeWindows = self.timetable.friday;
            dayOfWeek = NSLocalizedStringFromTable(@"Friday", @"Horaires", nil);
            break;
        case 5:
            timeWindows = self.timetable.saturday;
            dayOfWeek = NSLocalizedStringFromTable(@"Saturday", @"Horaires", nil);
            break;
        case 6:
            timeWindows = self.timetable.sunday;
            dayOfWeek = NSLocalizedStringFromTable(@"Sunday", @"Horaires", nil);
            break;
    }

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
