//
//  SearchFilterViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/19/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "SearchFilterViewController.h"
#import "SearchFilterTableViewCell.h"

@interface SearchFilterViewController ()

@end

@implementation SearchFilterViewController
{
    NSMutableArray *queryfilters;
    // Temporary Datas
    NSArray *sectionTitles;
    NSArray *sectionContent;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewAndData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setFilterForQuery:)
                                                 name:@"filterSelected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeFilterForQuery:)
                                                 name:@"filterUnselected"
                                               object:nil];
    
    //temporary data TO REMOVE
    
    sectionTitles = [[NSArray alloc]initWithObjects: NSLocalizedStringFromTable(@"Pour qui ?", @"Around_Me", nil), nil];
    sectionContent = [[NSArray alloc] initWithObjects:
                      NSLocalizedStringFromTable(@"Man", @"Claim", nil),NSLocalizedStringFromTable(@"Woman", @"Claim", nil),NSLocalizedStringFromTable(@"Kid", @"Claim", nil), nil];
    
        // Do any additional setup after loading the view.
}

/// NSNotification Methods

-(void)setFilterForQuery:(NSNotification*)notification {
    SearchFilterTableViewCell *cell = notification.object;
    
    NSIndexPath * indexPath = [self.searchFiltersTable indexPathForCell:cell];
    
    
    // Temporary filters
    
    if (indexPath.row == 0){
        [queryfilters addObject:@"men"];
        
    } else if (indexPath.row == 1){
         [queryfilters addObject:@"women"];
        
    } else{
        
         [queryfilters addObject:@"children"];
    }
    NSLog(@"query filters add %@", queryfilters);
}


-(void)removeFilterForQuery:(NSNotification*)notification {
    
    [queryfilters removeObject:@"men"];
    NSLog(@"queryfilters %@", queryfilters);
}

//// Init methods

-(void)initViewAndData {
    
    self.topBarTitle.text = NSLocalizedStringFromTable(@"Search", @"Around_Me", nil);
    [self.topBarView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];
    [self styleTextField:self.searchTextField];
    [self styleTextField:self.locationTextField];
}



-(void)styleTextField:(UITextField*)aTextField {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    aTextField.layer.cornerRadius = 5;
    aTextField.layer.masksToBounds = YES;
    aTextField.layer.borderWidth = 1;
    aTextField.layer.borderColor = [UIColor colorWithRed:218/255.0f green:218/255.0f blue:218/255.0f alpha:1].CGColor;
    aTextField.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    aTextField.leftViewMode = UITextFieldViewModeAlways;
    aTextField.leftView = paddingView;
}

//// Button Actions


// Navigation
-(IBAction)goBack:(id)sender {
    
    if (self.isModal == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

// Search

-(IBAction)doSearch:(id)sender
{
    BusinessSearch *businessSearch = [[BusinessSearch alloc] init];
    
    
    
    if (self.isModal == YES) {
        
        businessSearch.where = @"YOLO TEST";
        if([self.myDelegate respondsToSelector:@selector(didSetABusinessSearch:)])
        {
            [self.myDelegate didSetABusinessSearch:businessSearch];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self performSegueWithIdentifier:@"displayResultsSearch" sender:self];
}


//// TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}





//// Table View Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitles count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"searchFilterCell";
    SearchFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchFilterTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.titleLabel.text = [sectionContent objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sectionContent count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    headerView.backgroundColor = [UIColor colorWithRed:246/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [headerView addBottomBorderWithHeight:1 andColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1]];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 45)];
    headerLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    headerLabel.textColor = [UIColor colorWithRed:131/255.0f green:138/255.0f blue:151/255.0f alpha:1];
    headerLabel.text = [sectionTitles objectAtIndex:section];
    [headerView addSubview:headerLabel];
    return headerView;
}

/// Other funcs

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
