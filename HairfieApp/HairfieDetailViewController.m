//
//  HairfieDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieDetailViewController.h"
#import "HairfieDetailTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CustomCollectionViewCell.h"
#import "HairfieDetailCollectionReusableView.h"
#import "CommentViewController.h"

@interface HairfieDetailViewController ()

@end

@implementation HairfieDetailViewController

@synthesize myScrollView = _myScrollView, infoTableView = _infoTableView, hairfieImageView = _hairfieImageView, commentTableView = _commentTableView, addCommentBttn = _addCommentBttn, moreCommentBttn = _moreCommentBttn;

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoTableView.backgroundColor = [UIColor clearColor];
   // _hairfieImageView.clipsToBounds = YES;
    _infoTableView.scrollEnabled = NO;
    _hairfieCollection.delegate = self;
    _hairfieCollection.dataSource = self;
    _addCommentBttn.layer.cornerRadius = 5;
    _addCommentBttn.layer.masksToBounds = YES;
     _moreCommentBttn.layer.cornerRadius = 5;
    _moreCommentBttn.layer.masksToBounds = YES;
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"hairfieRelated"];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"HairfieDetailCollectionReusableView" bundle:nil]forCellWithReuseIdentifier:@"headerCollection"];
    [_addComment setValue:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];



    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];

    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 2.0f;
    profilePicture.layer.borderColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.1].CGColor;
    [_infoView addSubview:profilePicture];

    //UIView *test =
    //[self.view addSubview:profilePicture];
    //[_hairfieCollection setFrame:CGRectMake(0, 601, 320, 800)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



-(void)addGradientToView:(UIView*)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[[UIColor clearColor] CGColor],
                        (id)[[UIColor blackColor] CGColor]];
    [gradient setStartPoint:CGPointMake(0.0f, 1.0f)];
    [gradient setEndPoint:CGPointMake(0.0f, 0.6f)];
    [view.layer insertSublayer:gradient atIndex:0];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _infoTableView)
        return 3;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _commentTableView)
        return 130;
    return 43;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   if (tableView == _infoTableView)
   {
        static NSString *CellIdentifier = @"infoCell";
        HairfieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairfieDetailTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }


     _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

     UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 1024, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:236/255.0f green:237/255.0f  blue:237/255.0f  alpha:1].CGColor;
     separatorView.layer.borderWidth = 1.0;
     [cell.contentView addSubview:separatorView];

    if (indexPath.row == 0)
    {
        cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-hairdresser.png"];
        cell.contentLabel.text = @"Franck Provost, 75002 Paris";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    if (indexPath.row == 1)
    {
        cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-employee.png"];
        cell.contentLabel.text = @"Kimi Smith";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2)
    {
        cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-price.png"];
        cell.contentLabel.text = @"$ 40";
    }
        cell.backgroundColor = [UIColor clearColor];
         return cell;
   }
    else
    {
        static NSString *CellIdentifier = @"commentCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    return nil;
}


// Collection View delegate


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// header view size

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(320, 1065);
}

// header view data source

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hairfieDetailHeaderView" forIndexPath:indexPath];


    // Hairfitter profile pic (added manually because circled view)

    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 367, 40, 40)];
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];

    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 2.0f;
    profilePicture.layer.borderColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.1].CGColor;
    [headerView addSubview:profilePicture];

    return headerView;
}


- (CustomCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

      static NSString *CellIdentifier = @"hairfieRelated";
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.name.text = @"Kimi Smith";
    cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    cell.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    cell.layer.borderWidth = 1.0f;
    return cell;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addComment"])
    {
        CommentViewController *comment = [segue destinationViewController];
        comment.isCommenting = YES;
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
