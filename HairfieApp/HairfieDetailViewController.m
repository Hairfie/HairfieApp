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
#import "UserProfileViewController.h"
#import "CommentViewController.h"
#import <LoopBack/LoopBack.h>
#import "Hairfie.h"
#import "AppDelegate.h"
#import "NotLoggedAlert.h"
#import "UIRoundImageView.h"


@interface HairfieDetailViewController ()

@end

@implementation HairfieDetailViewController
{
    UIView *hairfieDetailView;
    UIView *hairfieView;
    UILabel *nbLike;
    UITableView *detailsTableView;
    UIButton *likeButton;
    UIImageView *likeView;
    NSArray *displayedInfoNames;
    NSArray *menuActions;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _hairfieCollection.delegate = self;
    _hairfieCollection.dataSource = self;

    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"hairfieRelated"];
   // [_hairfieCollection registerNib:[UINib nibWithNibName:@"HairfieDetailCollectionReusableView" bundle:nil]forCellWithReuseIdentifier:@"headerCollection"];

    [_hairfieCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    // Hotfix, should be better organized
    nbLike = [[UILabel alloc] init];
    
    [self reloadData];

    self.headerTitleLabel.text = [NSString stringWithFormat:@"%@'s Hairfie", self.hairfie.author.firstName];
     [_topBarView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];
    menuActions = @[
                    @{@"label": NSLocalizedStringFromTable(@"Report content", @"Hairfie_Detail",nil), @"segue": @"reportContent"}
                    ];
}

-(IBAction)showMenuActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (NSDictionary *menuAction in menuActions) {
        [actionSheet addButtonWithTitle:NSLocalizedStringFromTable([menuAction objectForKey:@"label"], @"Hairfie_Detail", nil)];
    }
    
    [actionSheet showInView:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ARAnalytics pageView:@"AR - Hairfie Detail"];
    [ARAnalytics event:@"AR - Hairfie Detail" withProperties:@{@"Hairfie ID": self.hairfie.id, @"Author": self.hairfie.author.name}];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailsTableView) {
        return displayedInfoNames.count;
    }

    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTableView) {
        NSString *infoName = displayedInfoNames[indexPath.row];
        if ([infoName isEqualToString:@"business"]) {
            // the current hairfie's business property contains a
            // partial business object, so we need to fetch the
            // complete version prior to show details
            [Business getById:self.hairfie.business.id
                  withSuccess:^(Business *business) {
                      [self performSegueWithIdentifier:@"businessDetail" sender:business];
                  }
                      failure:^(NSError *error) {
                          NSLog(@"Failed to retrieve complete business: %@", error.localizedDescription);
                      }];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
            cell.contentLabel.text = self.hairfie.business.displayNameAndAddress;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ([infoName isEqualToString:@"price"]) {
            cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-price.png"];
            cell.userInteractionEnabled = false;
            cell.contentLabel.text = self.hairfie.displayPrice;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if ([infoName isEqualToString:@"hairdresser"]) {
            // TODO: complete me
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

// header view size


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    float height = MAX((323 + 100 + displayedInfoNames.count * 50), (self.view.frame.size.height - _topBarView.frame.size.height + 10));


    return CGSizeMake(320, height);
}

// header view data source

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *collectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

    // HAIRFIE

    hairfieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 323)];
    hairfieView.backgroundColor = [UIColor lightGreyHairfie];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0, 320, 320, 3.0f);
    bottomBorder.backgroundColor = [UIColor pinkHairfie].CGColor;
    [hairfieView.layer addSublayer:bottomBorder];
    
    UIImageView *hairfieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [hairfieImageView sd_setImageWithURL:[NSURL URLWithString:self.hairfie.hairfieDetailUrl]
                      placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];

    hairfieImageView.contentMode = UIViewContentModeScaleAspectFit;
    hairfieImageView.clipsToBounds = YES;
    
    likeView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 130, 60, 60)];
    [likeView setImage:[UIImage imageNamed:@"likes-picto.png"]];
    [hairfieImageView addSubview:likeView];
    [likeView setHidden:YES];

    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(262, 290, 25, 20)];
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
        [User isHairfie:self.hairfie.id
            likedByUser:currentUser.id
                success:^(BOOL liked) {
                    [likeButton setSelected:liked];
                }
                failure:^(NSError *error) {
                    NSLog(@"Failed to get like status: %@", error.localizedDescription);
                }];
    }

    [nbLike setFrame:CGRectMake(295, 290, 35, 21)];
    nbLike.textColor = [UIColor whiteColor];
    nbLike.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];

    [hairfieView addSubview:hairfieImageView];
    [hairfieView addSubview:likeButton];
    [hairfieView addSubview:nbLike];

    // HAIRFIE DETAIL

    hairfieDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 333, 320, 100)];

    UIRoundImageView *borderProfile = [[UIRoundImageView alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [borderProfile setBackgroundColor:[[UIColor blackHairfie] colorWithAlphaComponent:0.2]];
    UIRoundImageView *profilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(12, 2, 40, 40)];
    [profilePicture sd_setImageWithURL:[NSURL URLWithString:self.hairfie.author.thumbUrl] placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
   

    
    
    UIButton *usernameButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 160, 30)];
    [usernameButton addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
    usernameButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [usernameButton setTitle:self.hairfie.author.displayName forState:UIControlStateNormal];
    [usernameButton setTitleColor:[[UIColor blackHairfie] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
    usernameButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
   // usernameButton.titleLabel.adjustsFontSizeToFitWidth = YES;

    
    UILabel *nbHairfies = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 92, 21)];
    nbHairfies.text = self.hairfie.author.displayHairfies;
    nbHairfies.font = [UIFont fontWithName:@"SourceSansPro-Light" size:13];
    nbHairfies.textColor = [[UIColor blackHairfie]colorWithAlphaComponent:0.8];


    UILabel *createdAt = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 200, 30)];
    createdAt.text = [self.hairfie displayTimeAgo];
    createdAt.textAlignment = NSTextAlignmentRight;
    createdAt.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    createdAt.textColor = [[UIColor blackHairfie]colorWithAlphaComponent:0.8];
    
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, 280, 54)];
    descLabel.numberOfLines = 2;
    descLabel.attributedText = self.hairfie.displayDescAndTags;
//    descLabel.text = self.hairfie.description;
//    descLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:12];
//    descLabel.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.8];

    [hairfieDetailView addSubview:borderProfile];
    [hairfieDetailView addSubview:profilePicture];
    [hairfieDetailView addSubview:usernameButton];
    [hairfieDetailView addSubview:nbHairfies];
    [hairfieDetailView addSubview:createdAt];
    [hairfieDetailView addSubview:descLabel];

    // RESTE

    detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 432, 320, 154)];
    detailsTableView.dataSource = self;
    detailsTableView.delegate = self;
    detailsTableView.backgroundColor = [UIColor clearColor];
    detailsTableView.scrollEnabled = NO;

    [collectionHeaderView addSubview:hairfieView];
    [collectionHeaderView addSubview:hairfieDetailView];
    [collectionHeaderView addSubview:detailsTableView];

    return collectionHeaderView;
}

-(IBAction)showProfile:(id)sender
{
    [self performSegueWithIdentifier:@"showUserProfile" sender:self];
}

-(void)reloadData
{
    nbLike.text = [self.hairfie displayNumLikes];

    // calculate infos to be displayed
    NSMutableArray *tempDisplayedInfoNames = [[NSMutableArray alloc] init];
    if (self.hairfie.business) {
        [tempDisplayedInfoNames addObject:@"business"];
    }
    if (nil != self.hairfie.price) {
        [tempDisplayedInfoNames addObject:@"price"];
    }
    displayedInfoNames = [[NSArray alloc] initWithArray:tempDisplayedInfoNames];

    detailsTableView.hidden = (0 == displayedInfoNames.count);
}

-(void)likeButtonHandler:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = delegate.currentUser;

    if([delegate.credentialStore isLoggedIn]) {
        if ([likeButton isSelected]) {
            [User unlikeHairfie:self.hairfie.id
                         asUser:currentUser.id
                        success:^() {
                            [likeButton setSelected:NO];
                            
                            self.hairfie.numLikes = [NSNumber numberWithInt:([self.hairfie.numLikes intValue] - 1)];
                            [self reloadData];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"Failed to like hairfie: %@", error.localizedDescription);
                        }];
        } else {
            [User likeHairfie:self.hairfie.id
                       asUser:currentUser.id
                      success:^() {
                          [likeButton setSelected:YES];
                          [self doLikeAnimation];
                          self.hairfie.numLikes = [NSNumber numberWithInt:([self.hairfie.numLikes intValue] + 1)];
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

-(void)doLikeAnimation
{
    [likeView setHidden:NO];
    [likeView setFrame:CGRectMake(130, 130, 60, 60)];
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationDuration:0.5];
    [likeView setFrame:CGRectMake(160, 160, 0, 0)];
    [UIView commitAnimations];
}

-(void)doubleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self likeButtonHandler:nil];
    }
}

-(void) addComment
{
    [self performSegueWithIdentifier:@"addComment" sender:self];
}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CustomCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"hairfieRelated";
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.name.text = NSLocalizedStringFromTable(@"Kimi Smith", @"Hairfie_Detail", nil);
    cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    cell.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    cell.layer.borderWidth = 1.0f;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addComment"]) {
        CommentViewController *comment = [segue destinationViewController];
        comment.isCommenting = YES;
    } else if ([segue.identifier isEqualToString:@"businessDetail"]) {
        SalonDetailViewController *controller = [segue destinationViewController];
        controller.business = sender;
    }
    if ([segue.identifier isEqualToString:@"showUserProfile"])
    {
        
        UserProfileViewController *userProfile = [segue destinationViewController];
        
        [userProfile setUser:self.hairfie.author];
        userProfile.isCurrentUser = NO;

    }
}

@end
