//
//  HorairesViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HorairesViewController.h"
#import "HoraireTableViewCell.h"

@interface HorairesViewController ()

@end

@implementation HorairesViewController

@synthesize salon =_salon;

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"%@", _salon);
    
    
    _tableViewHeight.constant = _salon.count * 65;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
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
    return [_salon count];
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
    
    
    NSString *key = [_salon allKeys][indexPath.row];
    NSString *day = key;
    NSString *time = [_salon[key] componentsJoinedByString: @" / "];
    
   
    cell.day.text = day;
    cell.time.text = time;
    
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
