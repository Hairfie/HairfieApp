//
//  SearchFilterViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/19/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "SearchFilterViewController.h"
#import "SearchFilterTableViewCell.h"
#import <UIAlertView+Blocks.h>
#import "AppDelegate.h"
#import "SearchCategory.h"

@interface SearchFilterViewController ()

@end

#define CELL_ID  @"searchFilterCell"

@implementation SearchFilterViewController
{
    NSMutableArray *queryfilters;
    // Temporary Datas
    NSArray *sectionTitles;
    NSArray *sectionContent;
    NSString *queryWhere;
    NSString *queryName;
    BOOL isCancelling;

    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewAndData];
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    queryfilters = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setFilterForQuery:)
                                                 name:@"filterSelected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeFilterForQuery:)
                                                 name:@"filterUnselected"
                                               object:nil];
    
    //temporary data TO REMOVE
    
    sectionTitles = [[NSArray alloc]initWithObjects: NSLocalizedStringFromTable(@"Catégories", @"Around_Me", nil), nil];
    sectionContent = delegate.categories;
    
    
    
    
        // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    isCancelling = NO;
    if (self.businessSearch != nil) {
        self.searchTextField.text = self.businessSearch.query;
        self.locationTextField.text = self.businessSearch.where;
        [self.searchFiltersTable reloadData];
        
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    if (isCancelling == NO) {
        if (self.isModifyingSearch == NO) {
            
            NSDictionary* dict = [NSDictionary dictionaryWithObject:self.businessSearch
                                                             forKey:@"businessSearch"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"segueToSearchResults"
                                                                object:nil
                                                              userInfo:dict];
        } if (self.isModifyingSearch == YES) {
            if ([self.myDelegate respondsToSelector:@selector(didSetABusinessSearch:)]) {
                [self.myDelegate didSetABusinessSearch:self.businessSearch];
            }
        }
    }
}
/// NSNotification Methods

-(void)setFilterForQuery:(NSNotification*)notification {
    SearchFilterTableViewCell *cell = notification.object;
    
    NSIndexPath * indexPath = [self.searchFiltersTable indexPathForCell:cell];
    
    SearchCategory *cat = [sectionContent objectAtIndex:indexPath.row];
    
    [queryfilters addObject:cat];
}


-(void)removeFilterForQuery:(NSNotification*)notification {
    
    SearchFilterTableViewCell *cell = notification.object;
    
    NSIndexPath * indexPath = [self.searchFiltersTable indexPathForCell:cell];
    
    SearchCategory *cat = [sectionContent objectAtIndex:indexPath.row];
    
    [queryfilters removeObject:cat];
}

//// Init methods

-(void)initViewAndData
{
    self.topBarTitle.text = NSLocalizedStringFromTable(@"Search", @"Around_Me", nil);
}

//// Button Actions


// Navigation
-(IBAction)goBack:(id)sender {
    
    isCancelling = YES;
    [self dismissViewControllerAnimated:YES completion:nil];

}

// Search


-(IBAction)doSearch:(id)sender
{
    self.businessSearch = [[BusinessSearch alloc] init];
    
    
    if (self.locationTextField.text == (id)[NSNull null] || self.locationTextField.text.length == 0 ) {
        self.businessSearch.where = @"";
    } else {
        self.businessSearch.where = queryWhere;
    }
    
    self.businessSearch.query = queryName;
    self.businessSearch.categories = queryfilters;
    
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"displayResultsSearch"]) {
        AroundMeViewController *aroundMeVc = [segue destinationViewController];
        
        aroundMeVc.businessSearch = self.businessSearch;
        
    }
    
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
        queryName = self.searchTextField.text;
        queryWhere = self.locationTextField.text;
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
    
    SearchFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchFilterTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    SearchCategory *cat = [sectionContent objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = cat.name;
    cell.tag = [cat.position integerValue];
    
    NSDictionary *alreadySelectedDic = _.find(self.businessSearch.categories, ^BOOL (SearchCategory *valueToTest) {
        return [valueToTest.name isEqualToString:cat.name];
    });
    
    if(alreadySelectedDic) {
        [cell setFilterSelected:YES];
        cell.isSelected = YES;
        [queryfilters addObject:cat];
    }else {
        cell.isSelected = NO;
    }
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    headerView.backgroundColor = [UIColor colorWithRed:246/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [headerView addBottomBorderWithHeight:1 andColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1]];

    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 45)];
    headerLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    headerLabel.textColor = [UIColor colorWithRed:131/255.0f green:138/255.0f blue:151/255.0f alpha:1];
    headerLabel.text = [sectionTitles objectAtIndex:section];

    [headerView addSubview:headerLabel];
    
    return headerView;
}

@end
