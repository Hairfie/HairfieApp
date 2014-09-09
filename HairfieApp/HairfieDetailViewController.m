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
#import <LoopBack/LoopBack.h>

@interface HairfieDetailViewController ()



@end

@implementation HairfieDetailViewController
{
    UITableView *detailsTableView;
    UITableView *commentsTableView;
    LBModel *model;
}

@synthesize myScrollView = _myScrollView, hairfieImageView = _hairfieImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"current hairfie : %@", _currentHairfie);

    _hairfieCollection.delegate = self;
    _hairfieCollection.dataSource = self;
    model = (LBModel *)_currentHairfie;
    
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"hairfieRelated"];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"HairfieDetailCollectionReusableView" bundle:nil]forCellWithReuseIdentifier:@"headerCollection"];

     [_hairfieCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
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
    if (tableView == detailsTableView)
        return 3;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == commentsTableView)
        return 130;
    return 43;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   if (tableView == detailsTableView)
   {
        static NSString *CellIdentifier = @"infoCell";
        HairfieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairfieDetailTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }


     detailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
        cell.contentLabel.text = [NSString stringWithFormat:@"%@ €", [[model objectForKeyedSubscript:@"price"] valueForKey:@"amount"]];
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
    UICollectionReusableView *collectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    // HEADER
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    UIImage *backButtonImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 30, 20, 20)];
    [backButton setImage:backButtonImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(92, 27, 136, 23)];
    headerTitle.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    headerTitle.textColor = [UIColor whiteColor];
    headerTitle.text = @"Fiche Hairfie";
    
    [headerView addSubview:backButton];
    [headerView addSubview:headerTitle];
    
    // HAIRFIE
    
    
    
    UIView *hairfieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 358)];
    hairfieView.backgroundColor = [UIColor lightBlueHairfie];
    UIImageView *hairfieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 355)];

    [hairfieImageView sd_setImageWithURL:[[model objectForKeyedSubscript:@"pictureObj"] objectForKey:@"publicUrl"]
                      placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    hairfieImageView.contentMode =UIViewContentModeScaleAspectFill;
    
    UIImageView *likePicto = [[UIImageView alloc] initWithFrame:CGRectMake(10, 328, 25, 20)];
    likePicto.image = [UIImage imageNamed:@"picto-hairfie-detail-like.png"];
    UILabel *nbLike = [[UILabel alloc] initWithFrame:CGRectMake(43, 328, 35, 21)];
    nbLike.text = @"200";
    nbLike.textColor = [UIColor whiteColor];
    nbLike.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    UIImageView *commentPicto = [[UIImageView alloc] initWithFrame:CGRectMake(86, 328, 26, 20)];
    commentPicto.image = [UIImage imageNamed:@"picto-hairfie-comment.png"];
    UILabel *nbComment = [[UILabel alloc] initWithFrame:CGRectMake(120, 328, 54, 21)];
    nbComment.text = @"200";
    nbComment.textColor = [UIColor whiteColor];
    nbComment.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    [hairfieView addSubview:hairfieImageView];
    [hairfieView addSubview:likePicto];
    [hairfieView addSubview:nbLike];
    [hairfieView addSubview:commentPicto];
    [hairfieView addSubview:nbComment];
    
    // HAIRFIE DETAIL
    
    UIView *hairfieDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 359, 320, 100)];
  
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 2.0f;
    profilePicture.layer.borderColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.1].CGColor;
   
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 8, 111, 21)];
    usernameLabel.text = @"Leo M.";
    usernameLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    usernameLabel.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.4] ;
    
    UILabel *nbHairfies = [[UILabel alloc]initWithFrame:CGRectMake(68, 30, 92, 21)];
    nbHairfies.text = @"350 hairfies";
    nbHairfies.font = [UIFont fontWithName:@"SourceSansPro-Light" size:13];
    nbHairfies.textColor = [[UIColor blackHairfie]colorWithAlphaComponent:0.8];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, 280, 54)];
    descLabel.numberOfLines = 2;
    descLabel.text = [model objectForKeyedSubscript:@"description"];
    descLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:12];
    descLabel.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.8];
    
    [hairfieDetailView addSubview:profilePicture];
    [hairfieDetailView addSubview:usernameLabel];
    [hairfieDetailView addSubview:nbHairfies];
    [hairfieDetailView addSubview:descLabel];
    
    // RESTE
    
    detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 457, 320, 154)];
    detailsTableView.dataSource = self;
    detailsTableView.delegate = self;
    detailsTableView.backgroundColor = [UIColor clearColor];
    detailsTableView.scrollEnabled = NO;
    
   
    UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 619, 185, 21)];
    commentsLabel.text = @"Commentaires du Hairfie";
    commentsLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    commentsLabel.textColor = [UIColor darkBlueHairfie];
    
    UIView *commentLineBreaker = [[UIView alloc] initWithFrame:CGRectMake(10, 643, 185, 1)];
    commentLineBreaker.backgroundColor = [UIColor lightGreyHairfie];
    UIImage *addCommentImage = [UIImage imageNamed:@"add-comment-textfield.png"];
    UIButton *bigAddCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [bigAddCommentButton setImage:addCommentImage forState:UIControlStateNormal];
    [bigAddCommentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    
    [bigAddCommentButton setFrame:CGRectMake(10, 658, 300, 36)];
   
    UILabel *addCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 665, 138, 21)];
    addCommentLabel.text = @"add a comment...";
    addCommentLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14];
    addCommentLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 712, 320, 294)];
    commentsTableView.dataSource = self;
    commentsTableView.delegate = self;
    commentsTableView.scrollEnabled = NO;
    
    UIButton *addCommentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addCommentButton.layer.cornerRadius = 5;
    addCommentButton.layer.masksToBounds = YES;
    [addCommentButton setFrame:CGRectMake(58, 989, 110, 30)];
    addCommentButton.backgroundColor = [UIColor lightBlueHairfie];
   
    [addCommentButton setTitle:@"Add a comment" forState:UIControlStateNormal];
    [addCommentButton setTitle:@"Add a comment" forState:UIControlStateHighlighted];
    [addCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    addCommentButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
  //  addCommentButton.titleLabel.textColor = [UIColor whiteColor];
     [addCommentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moreCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreCommentButton.layer.cornerRadius = 5;
    moreCommentButton.layer.masksToBounds = YES;
    [moreCommentButton setFrame:CGRectMake(181, 989, 129, 30)];
    moreCommentButton.backgroundColor = [UIColor lightBlueHairfie];
    [moreCommentButton setTitle:@"More comments (20)" forState:UIControlStateNormal];
    [moreCommentButton setTitle:@"More comments (20)" forState:UIControlStateHighlighted];
    [moreCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    moreCommentButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
   // moreCommentButton.titleLabel.textColor = [UIColor whiteColor];
    [moreCommentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *similarHairfieLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1035, 191, 21)];
    similarHairfieLabel.text = @"Hairfies du même coiffeur";
    similarHairfieLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    similarHairfieLabel.textColor = [UIColor darkBlueHairfie];
   
    UIView *similarLineBreaker = [[UIView alloc] initWithFrame:CGRectMake(10, 1055, 186, 1)];
    similarLineBreaker.backgroundColor = [UIColor lightGreyHairfie];
    // Hairfitter profile pic (added manually because circled view)


    [collectionHeaderView addSubview:headerView];
    [collectionHeaderView addSubview:hairfieView];
    [collectionHeaderView addSubview:hairfieDetailView];
    
    [collectionHeaderView addSubview:detailsTableView];
    [collectionHeaderView addSubview:commentsLabel];
    [collectionHeaderView addSubview:commentLineBreaker];
    [collectionHeaderView addSubview:bigAddCommentButton];
    [collectionHeaderView addSubview:addCommentLabel];
    [collectionHeaderView addSubview:commentsTableView];
    [collectionHeaderView addSubview:addCommentButton];
    [collectionHeaderView addSubview:moreCommentButton];
    [collectionHeaderView addSubview:similarHairfieLabel];
    [collectionHeaderView addSubview:similarLineBreaker];
    
    /*
    _name.text = @"COUCIU";
     _hairfieImageView.image = _hairfieImage;
    
    [collectionHeaderView addSubview:profilePicture];
     */
    return collectionHeaderView;
}

-(void) addComment
{
    [self performSegueWithIdentifier:@"addComment" sender:self];
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
