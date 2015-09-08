//
//  AddTagsToHairfieViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AddTagsToHairfieViewController.h"
#import "HairfiePostDetailsViewController.h"
#import "TagsTableViewCell.h"
#import "UIView+Borders.h"
#import "Tag.h"


@interface AddTagsToHairfieViewController ()

@end

@implementation AddTagsToHairfieViewController
{
    AppDelegate *appDelegate;
    NSArray *tags;
    NSMutableArray *hairfieTags;
    NSInteger nbLines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    hairfieTags = [NSMutableArray arrayWithArray:appDelegate.hairfieUploader.hairfiePost.tags];
    self.tagsDictionary = [[NSMutableDictionary alloc] init];
    [self.topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
    self.validateBttn.layer.cornerRadius = 5;
    self.validateBttn.layer.masksToBounds = YES;
    [self initTags];
    
    self.tagsTableView.estimatedRowHeight = 100;
    // Do any additional setup after loading the view.
}


-(void)initTags
{
    
    tags = appDelegate.tags;
    [self.tagsTableView reloadData];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tags.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagsTableViewCell *cell = [self configureCellAtIndex:indexPath];
    return [cell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureCellAtIndex:indexPath];
}


-(TagsTableViewCell *)configureCellAtIndex:(NSIndexPath*)indexPath
{
    
    static NSString *CellIdentifier = @"tagCell";
    TagsTableViewCell *cell = [self.tagsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *tagGroup = [tags objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TagsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    
    TagCategory *category = [tagGroup objectAtIndex:0];
    NSArray *tagsFromCategory = [tagGroup objectAtIndex:1];
    cell.tagCategory.text = category.name;
    cell.tag = indexPath.row;
    [cell setTags:tagsFromCategory withSelectedTags:hairfieTags];
    cell.delegate = self;
    
    return cell;
}

-(void)tagWasSelected:(Tag *)tag isSelected:(BOOL)selected
{
    if (selected == YES)
        [hairfieTags addObject:tag];
    else
    {
        
        NSArray *filteredHairfies = _.reject(hairfieTags, ^BOOL(Tag *hairfieTag) {
         
            return [tag.id isEqualToString:hairfieTag.id];
        });
        
        hairfieTags = [NSMutableArray arrayWithArray:filteredHairfies];
        
    }
}


-(IBAction)validateTags:(id)sender
{
    appDelegate.hairfieUploader.hairfiePost.tags = hairfieTags;
    [self goBack:self];
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
