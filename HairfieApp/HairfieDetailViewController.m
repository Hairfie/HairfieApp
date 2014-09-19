//
//  HairfieDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieDetailViewController.h"
#import "SalonDetailViewController.h"
#import "HairfieDetailTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CustomCollectionViewCell.h"
#import "HairfieDetailCollectionReusableView.h"
#import "CommentViewController.h"
#import <LoopBack/LoopBack.h>
#import "Hairfie.h"
#import "AppDelegate.h"
#import "NotLoggedAlert.h"

@interface HairfieDetailViewController ()

@end

@implementation HairfieDetailViewController
{
    UIView *hairfieDetailView;
    UILabel *nbLike;
    UITableView *detailsTableView;
    UITableView *commentsTableView;
    UIButton *likeButton;
    UIImageView *likeView;
    NSArray *displayedInfoNames;
}

@synthesize myScrollView = _myScrollView, hairfieImageView = _hairfieImageView;

- (void)viewDidLoad {
    [super viewDidLoad];

    _hairfieCollection.delegate = self;
    _hairfieCollection.dataSource = self;

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
    if (tableView == detailsTableView) {
        return displayedInfoNames.count;
    }

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == commentsTableView)
        return 130;
    return 43;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTableView) {
        NSString *infoName = displayedInfoNames[indexPath.row];
        if ([infoName isEqualToString:@"business"]) {
            [self performSegueWithIdentifier:@"businessDetail" sender:self.currentHairfie.business];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTableView) {
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

        NSString *infoName = displayedInfoNames[indexPath.row];

        if ([infoName isEqualToString:@"business"]) {
            cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-hairdresser.png"];
            cell.contentLabel.text = _currentHairfie.business.displayNameAndAddress;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ([infoName isEqualToString:@"price"]) {
            cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-price.png"];
            cell.contentLabel.text = self.currentHairfie.displayPrice;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ([infoName isEqualToString:@"hairdresser"]) {
            // TODO: complete me
            //cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-employee.png"];
            //cell.contentLabel.text = @"Kimi Smith";
        }

        return cell;
    } else {
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



    UIView *hairfieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 323)];
    hairfieView.backgroundColor = [UIColor lightGreyHairfie];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0, 320, 320, 3.0f);
    bottomBorder.backgroundColor = [UIColor lightBlueHairfie].CGColor;
    [hairfieView.layer addSublayer:bottomBorder];
    
    UIImageView *hairfieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [hairfieImageView sd_setImageWithURL:[NSURL URLWithString:_currentHairfie.hairfieDetailUrl]
                      placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];

    hairfieImageView.contentMode = UIViewContentModeScaleAspectFit;
    hairfieImageView.clipsToBounds = YES;
    
    likeView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 130, 60, 60)];
    [likeView setImage:[UIImage imageNamed:@"likes-picto.png"]];
    [hairfieImageView addSubview:likeView];
    [likeView setHidden:YES];

    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 290, 25, 20)];
    [likeButton setImage:[UIImage imageNamed:@"picto-hairfie-detail-liked.png"] forState:UIControlStateSelected];
    [likeButton setImage:[UIImage imageNamed:@"picto-hairfie-detail-like.png"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likeButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    hairfieImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [hairfieImageView addGestureRecognizer:tapGesture];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = delegate.currentUser;
    if (currentUser != nil) {
        [User isHairfie:self.currentHairfie.id
            likedByUser:currentUser.id
                success:^(BOOL liked) {
                    [likeButton setSelected:liked];
                }
                failure:^(NSError *error) {
                    NSLog(@"Failed to get like status: %@", error.localizedDescription);
                }];
    }


    nbLike = [[UILabel alloc] initWithFrame:CGRectMake(43, 290, 35, 21)];
    nbLike.textColor = [UIColor whiteColor];
    nbLike.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];

    UIImageView *commentPicto = [[UIImageView alloc] initWithFrame:CGRectMake(86, 290, 26, 20)];
    commentPicto.image = [UIImage imageNamed:@"picto-hairfie-comment.png"];

    UILabel *nbComment = [[UILabel alloc] initWithFrame:CGRectMake(120, 290, 54, 21)];
    nbComment.text = [self.currentHairfie displayNumComments];
    nbComment.textColor = [UIColor whiteColor];
    nbComment.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];

    [hairfieView addSubview:hairfieImageView];
    [hairfieView addSubview:likeButton];
    [hairfieView addSubview:nbLike];
    [hairfieView addSubview:commentPicto];
    [hairfieView addSubview:nbComment];

    // HAIRFIE DETAIL

    hairfieDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 334, 320, 100)];

    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    [profilePicture sd_setImageWithURL:[NSURL URLWithString:_currentHairfie.author.thumbUrl] placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 2.0f;
    profilePicture.layer.borderColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.1].CGColor;

    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 8, 111, 21)];
    usernameLabel.text = _currentHairfie.author.displayName;
    usernameLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    usernameLabel.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.4] ;

    
    UILabel *nbHairfies = [[UILabel alloc]initWithFrame:CGRectMake(68, 30, 92, 21)];
    nbHairfies.text = _currentHairfie.author.displayHairfies;
    nbHairfies.font = [UIFont fontWithName:@"SourceSansPro-Light" size:13];
    nbHairfies.textColor = [[UIColor blackHairfie]colorWithAlphaComponent:0.8];

    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, 280, 54)];
    descLabel.numberOfLines = 2;
    descLabel.text = _currentHairfie.description;
    descLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:12];
    descLabel.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.8];

    [hairfieDetailView addSubview:profilePicture];
    [hairfieDetailView addSubview:usernameLabel];
    [hairfieDetailView addSubview:nbHairfies];
    [hairfieDetailView addSubview:descLabel];

    // RESTE

    detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 432, 320, 154)];
    detailsTableView.dataSource = self;
    detailsTableView.delegate = self;
    detailsTableView.backgroundColor = [UIColor clearColor];
    detailsTableView.scrollEnabled = NO;


    UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 596, 185, 21)];
    commentsLabel.text = @"Commentaires du Hairfie";
    commentsLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    commentsLabel.textColor = [UIColor darkBlueHairfie];

    UIView *commentLineBreaker = [[UIView alloc] initWithFrame:CGRectMake(10, 618, 185, 1)];
    commentLineBreaker.backgroundColor = [UIColor lightGreyHairfie];
    UIImage *addCommentImage = [UIImage imageNamed:@"add-comment-textfield.png"];
    UIButton *bigAddCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [bigAddCommentButton setImage:addCommentImage forState:UIControlStateNormal];
    [bigAddCommentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];

    [bigAddCommentButton setFrame:CGRectMake(10, 633, 300, 36)];

    UILabel *addCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 640, 138, 21)];
    addCommentLabel.text = @"add a comment...";
    addCommentLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14];
    addCommentLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

    commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 687, 320, 294)];
    commentsTableView.dataSource = self;
    commentsTableView.delegate = self;
    commentsTableView.scrollEnabled = NO;

    UIButton *addCommentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addCommentButton.layer.cornerRadius = 5;
    addCommentButton.layer.masksToBounds = YES;
    [addCommentButton setFrame:CGRectMake(58, 964, 110, 30)];
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
    [moreCommentButton setFrame:CGRectMake(181, 964, 129, 30)];
    moreCommentButton.backgroundColor = [UIColor lightBlueHairfie];
    [moreCommentButton setTitle:@"More comments (20)" forState:UIControlStateNormal];
    [moreCommentButton setTitle:@"More comments (20)" forState:UIControlStateHighlighted];
    [moreCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    moreCommentButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
   // moreCommentButton.titleLabel.textColor = [UIColor whiteColor];
    [moreCommentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];

    UILabel *similarHairfieLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1010, 191, 21)];
    similarHairfieLabel.text = @"Hairfies du même coiffeur";
    similarHairfieLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    similarHairfieLabel.textColor = [UIColor darkBlueHairfie];

    UIView *similarLineBreaker = [[UIView alloc] initWithFrame:CGRectMake(10, 1030, 186, 1)];
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

    [self reloadData];
    
    /*
    _name.text = @"COUCIU";
     _hairfieImageView.image = _hairfieImage;

    [collectionHeaderView addSubview:profilePicture];
     */
    return collectionHeaderView;
}

-(void)reloadData
{
    nbLike.text = [self.currentHairfie displayNumLikes];

    // calculate infos to be displayed
    NSMutableArray *tempDisplayedInfoNames = [[NSMutableArray alloc] init];
    if (self.currentHairfie.business) {
        [tempDisplayedInfoNames addObject:@"business"];
    }
    if (![self.currentHairfie.price isEqual:[NSNull null]]) {
        [tempDisplayedInfoNames addObject:@"price"];
    }
    displayedInfoNames = [[NSArray alloc] initWithArray:tempDisplayedInfoNames];
}

-(void)likeButtonHandler:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = delegate.currentUser;

    if([delegate.credentialStore isLoggedIn]) {
        if ([likeButton isSelected]) {
            [User unlikeHairfie:self.currentHairfie.id
                         asUser:currentUser.id
                        success:^() {
                            [likeButton setSelected:NO];
                            
                            self.currentHairfie.numLikes = [NSNumber numberWithInt:([self.currentHairfie.numLikes intValue] - 1)];
                            [self reloadData];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"Failed to like hairfie: %@", error.localizedDescription);
                        }];
        } else {
            [User likeHairfie:self.currentHairfie.id
                       asUser:currentUser.id
                      success:^() {
                          [likeButton setSelected:YES];
                          [self doLikeAnimation];
                          self.currentHairfie.numLikes = [NSNumber numberWithInt:([self.currentHairfie.numLikes intValue] + 1)];
                          [self reloadData];
                      }
                      failure:^(NSError *error) {
                          NSLog(@"Failed to unlike hairfie: %@", error.localizedDescription);
                      }];
        }
    } else {
        [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
    }
}

-(void) doLikeAnimation {
    [likeView setHidden:NO];
    [likeView setFrame:CGRectMake(130, 130, 60, 60)];
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationDuration:0.5];
    [likeView setFrame:CGRectMake(160, 160, 0, 0)];
    [UIView commitAnimations];
}

- (void)doubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self likeButtonHandler:nil];
    }
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
    if ([segue.identifier isEqualToString:@"addComment"]) {
        CommentViewController *comment = [segue destinationViewController];
        comment.isCommenting = YES;
    } else if ([segue.identifier isEqualToString:@"businessDetail"]) {
        SalonDetailViewController *controller = [segue destinationViewController];
        controller.business = sender;
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
