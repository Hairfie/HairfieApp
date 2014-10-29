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
    NSMutableArray *tags;
    NSMutableArray *hairfieTags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hairfieTags = [NSMutableArray arrayWithArray:self.hairfiePost.tags];
    self.tagsDictionary = [[NSMutableDictionary alloc] init];
    [self.topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
    self.validateBttn.layer.cornerRadius = 5;
    self.validateBttn.layer.masksToBounds = YES;
    [self initTags];
    // Do any additional setup after loading the view.
}


-(void)initTags
{
    void (^successHandler)(NSArray *) = ^(NSArray *results) {
       
        tags = [NSMutableArray arrayWithArray:results];
        [self.tagsTableView reloadData];
    };
    
    void (^failureHandler)(NSError *) = ^(NSError *error) {
        NSLog(@"Failed to get tags with error %@", error.description);
    };
    
    [Tag getTagsGroupedByCategoryWithSuccess:successHandler failure:failureHandler];
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
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"tagCell";
    TagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *tagGroup = [tags objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TagsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];
    

    TagCategory *category = [tagGroup objectAtIndex:0];
    NSArray *tagsFromCategory = [tagGroup objectAtIndex:1];
    
    if (tableView == self.tagsTableView) {
        cell.tagCategory.text = category.name;
        cell.tag = indexPath.row;
        [cell setTags:tagsFromCategory withSelectedTags:hairfieTags];
        cell.delegate = self;
    }
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
    NSLog(@"HAIRFIE TAFS %@", hairfieTags);
}


-(IBAction)validateTags:(id)sender
{
    HairfiePostDetailsViewController *hairfiePostVc = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

    hairfiePostVc.hairfiePost.tags = hairfieTags;
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
