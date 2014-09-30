
//
//  testViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 30/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "testViewController.h"
#import "MenuTableViewCell.h"

@interface testViewController ()

@end

@implementation testViewController
{
     NSMutableArray *data;
    NSMutableArray *headers;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupMenu
{
    
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _menuItems = [[NSMutableArray alloc] init];
    
    
    _menuItems = [NSMutableArray arrayWithObjects: NSLocalizedStringFromTable(@"Home", @"Menu", nil), NSLocalizedStringFromTable(@"Likes", @"Menu", nil), nil];
    _menuPictos = [[NSMutableArray alloc] init];
    [_menuPictos addObject:@"home-picto.png"];
    [_menuPictos addObject:@"likes-picto.png"];
    
    data = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 3 ; i++)
    {
        NSMutableArray* section = [[NSMutableArray alloc] init];

        if (i == 0)
        for (int j = 0 ; j < 2 ; j++)
        {
            [section addObject:[NSString stringWithFormat:@"%@", [_menuItems objectAtIndex:j]]];
        }
        else
            [section addObject:[NSString stringWithFormat:@"Add a business"]];
        
        [data addObject:section];
    }
    
    
    headers = [[NSMutableArray alloc] init];

        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [header setBackgroundColor:[UIColor lightGrayColor]];
        UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 237, 40)];
        mylabel.text = @"Business";
        UIImageView *pictoBusiness = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
        pictoBusiness.image = [UIImage imageNamed:@"business-picto.png"];
        mylabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
        mylabel.textColor = [UIColor whiteColor];
        [header addSubview:pictoBusiness];
        [header addSubview:mylabel];
        [headers addObject:header];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenu];
    [_menuTableView reloadData];
    [_menuTableView setExclusiveSections:!_menuTableView.exclusiveSections];
    [_menuTableView openSection:0 animated:NO];
    [_menuTableView openSection:1 animated:NO];
    [_menuTableView openSection:2 animated:NO];
    
    
}



- (IBAction)handleExclusiveButtonTap:(UIButton*)button
{
    [_menuTableView setExclusiveSections:_menuTableView.exclusiveSections];
    
    //[button setTitle:_menuTableView.exclusiveSections?@"exclusive":@"!exclusive" forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    

    cell.backgroundColor = [UIColor lightGrayColor];
    if (indexPath.section == 0)
    {
        cell.menuItem.text = [_menuItems objectAtIndex:indexPath.row];
        [cell.menuPicto setImage:[UIImage imageNamed:[_menuPictos objectAtIndex:indexPath.row]]];
    }
    if (indexPath.section == 1)
    {
     cell.menuItem.text = @"Add a business";
        [cell.menuPicto setImage:[UIImage imageNamed:@"addBusiness-picto.png"]];
    }
    if (indexPath.section == 2)
    {
        [cell.menuPicto setImage:[UIImage imageNamed:@"picto-logout.png"]];
       cell.menuItem.text = @"Log Out";
    }
    cell.menuItem.textColor = [UIColor colorWithRed:208 green:210 blue:213 alpha:1];
    cell.menuItem.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 44;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1)
        return [headers objectAtIndex:0];
    else
        
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
