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
#import "CustomCollectionViewCell.h"
#import "UserProfileViewController.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "NotLoggedAlert.h"
#import "UIRoundImageView.h"
#import "HairfieDetailBusinessTableViewCell.h"
#import "InstagramSharer.h"
#import <Social/Social.h>

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
    UIDocumentInteractionController *documentController;
    UILabel *priceLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.hairfieCollection.delegate = self;
    self.hairfieCollection.dataSource = self;

    [self.hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]
             forCellWithReuseIdentifier:@"hairfieRelated"];

    [_hairfieCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    // Hotfix, should be better organized
    nbLike = [[UILabel alloc] init];
    
    [self reloadData];

    self.headerTitleLabel.text = [NSString stringWithFormat:@"%@'s Hairfie", self.hairfie.author.firstName];
     [_topBarView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];

    menuActions = @[
        @{
            @"label": NSLocalizedStringFromTable(@"Tweet", @"Hairfie_Detail", nil),
            @"share": @"twitter"
        },
        @{
            @"label": NSLocalizedStringFromTable(@"Share on Facebook", @"Hairfie_Detail", nil),
            @"share": @"facebook"
        },
        @{
            @"label": NSLocalizedStringFromTable(@"Post on Instagram", @"Hairfie_Detail", nil),
            @"share": @"instagram"
        }/*,
        @{
            @"label": NSLocalizedStringFromTable(@"Report content", @"Hairfie_Detail",nil),
            @"segue": @"reportContent"
        }*/
    ];
}

-(void)reloadData
{
    nbLike.text = [self.hairfie displayNumLikes];
      // calculate infos to be displayed
    NSMutableArray *tempDisplayedInfoNames = [[NSMutableArray alloc] init];
    if (self.hairfie.business) {
        [tempDisplayedInfoNames addObject:@"business"];
    }
    if (self.hairfie.hairdresser) {
        [tempDisplayedInfoNames addObject:@"hairdresser"];
    }
    if (self.hairfie.selfMade) {
        [tempDisplayedInfoNames addObject:@"selfMade"];
    }
    if (nil != self.hairfie.price) {
        [tempDisplayedInfoNames addObject:@"price"];
    }
    displayedInfoNames = [[NSArray alloc] initWithArray:tempDisplayedInfoNames];
    
    detailsTableView.hidden = (0 == displayedInfoNames.count);
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) return; // it's the cancel button

    NSDictionary *action = menuActions[buttonIndex - 1];
    NSString *segueName = [action objectForKey:@"segue"];
    NSString *shareName = [action objectForKey:@"share"];

    if (nil != segueName) {
        [self performSegueWithIdentifier:[menuActions[buttonIndex - 1] objectForKey:@"segue"] sender:self];
    } else if ([shareName isEqualToString:@"instagram"]) {
        [self shareOnInstagram];
    } else if ([shareName isEqualToString:@"twitter"]) {
        [self shareOnTwitter];
    } else if ([shareName isEqualToString:@"facebook"]) {
        [self shareOnFacebook];
    }
}

-(void)shareOnInstagram
{
    NSURL *imageURL = [NSURL URLWithString:[self.hairfie.picture urlWithWidth:@620 height:@620]];

    [InstagramSharer interactionControllerForImageWithURL:imageURL
                                                  success:^(UIDocumentInteractionController *dic) {
                                                      // we need to store it as instance variable to retain it
                                                      documentController = dic;
                                                      [documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0)
                                                                                             inView:self.view
                                                                                           animated:YES];
                                                  }
                                                  failure:^(NSError *error) {
                                                      NSLog(@"Failed to share on Instagram: %@", error.localizedDescription);
                                                  }];
}

-(void)shareOnTwitter
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSString *message = NSLocalizedStringFromTable(@"It seems that we cannot talk to Twitter at the moment or you have not yet added your Twitter account to this device.", @"Hairfie_Detail", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [vc addURL:self.hairfie.landingPageUrl];

        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)shareOnFacebook
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSString *message = NSLocalizedStringFromTable(@"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device.", @"Hairfie_Detail", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [vc addURL:self.hairfie.landingPageUrl];
    
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
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
    NSString *infoName = displayedInfoNames[indexPath.row];
    
    return [self heightForRowWithInfo:infoName];
}

-(CGFloat)heightForRowWithInfo:(NSString *)infoName
{
    if ([infoName isEqualToString:@"business"]) {
        return 100;
    }
    
    return 43;
}

-(CGFloat)infosTableHeight
{
    CGFloat height = 0;
    for (NSString *infoName in displayedInfoNames) {
        height = height + [self heightForRowWithInfo:infoName];
    }
    
    return height;
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
        } else if ([infoName isEqualToString:@"selfMade"]) {
            [self performSegueWithIdentifier:@"showUserProfile" sender:self];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTableView) {
        UITableViewCell *cell;
        
        NSString *infoName = displayedInfoNames[indexPath.row];
        if ([infoName isEqualToString:@"business"]) {
            cell = [self businessCellForTableView:tableView];
        } else {
            cell = [self info:infoName cellForTableView:tableView];
        }
        
        BOOL first = indexPath.row == 0;
        BOOL last = indexPath.row + 1 == displayedInfoNames.count;
        
        CGColorRef borderColor = [UIColor colorWithRed:236/255.0f green:237/255.0f  blue:237/255.0f  alpha:1].CGColor;
        
        if (first) {
            // add top border to the first item
            CGRect topBorderFrame = CGRectMake(0, 1, 1024, 1);
            UIView *topBorderView = [[UIView alloc] initWithFrame:topBorderFrame];
            topBorderView.layer.borderColor = borderColor;
            topBorderView.layer.borderWidth = 1.0;
            [cell.contentView addSubview:topBorderView];
        }
        
        // add separator
        CGRect separatorFrame = CGRectMake(40, cell.frame.size.height - 1, 1024, 1);
        if (last) {
            separatorFrame.origin.x = 0;
        }
        UIView *separatorView = [[UIView alloc] initWithFrame:separatorFrame];
        separatorView.layer.borderColor = borderColor;
        separatorView.layer.borderWidth = 1.0;
        [cell.contentView addSubview:separatorView];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    return nil;
}

-(UITableViewCell *)info:(NSString *)infoName cellForTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"infoCell";
    HairfieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairfieDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([infoName isEqualToString:@"price"]) {
        cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-price.png"];
        cell.userInteractionEnabled = false;
        cell.contentLabel.text = self.hairfie.displayPrice;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if ([infoName isEqualToString:@"hairdresser"]) {
        cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-hairdresser.png"];
        cell.userInteractionEnabled = false;
        cell.contentLabel.text = self.hairfie.hairdresser.displayFullName;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if ([infoName isEqualToString:@"selfMade"]) {
        cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-business.png"];
        cell.contentLabel.text = NSLocalizedStringFromTable(@"I did it", @"Hairfie_Detail", nil);

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        // same background color for accessory  
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        backgroundView.backgroundColor = cell.contentView.backgroundColor;
        cell.backgroundView = backgroundView;
    }
    
    return cell;
}

-(UITableViewCell *)businessCellForTableView:(UITableView *)tableView
{
    HairfieDetailBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"businessCell"];
    if (nil == cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairfieDetailBusinessTableViewCell" owner:self options:nil];
        cell = nib[0];
    }
    
    [cell setBusiness:self.hairfie.business];

    return cell;
}

// header view size


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    float height = MAX((350 + 100 + [self infosTableHeight]), (self.view.frame.size.height - _topBarView.frame.size.height + 10));

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
    
    UIView *priceBg =[[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    priceBg.layer.cornerRadius = priceBg.frame.size.height / 2;
    priceBg.clipsToBounds = YES;
    priceBg.backgroundColor = [UIColor salonDetailTab];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 40, 30)];
    priceLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
   
    priceLabel.minimumScaleFactor = 0.5;
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.text = [self.hairfie displayPrice];

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
    
    if (self.hairfie.price != nil)
        [hairfieView addSubview:priceBg];
        [hairfieView addSubview:priceLabel];
    // HAIRFIE DETAIL

    hairfieDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 333, 320, 100)];

    UIRoundImageView *borderProfile = [[UIRoundImageView alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [borderProfile setBackgroundColor:[[UIColor blackHairfie] colorWithAlphaComponent:0.2]];
    UIRoundImageView *profilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(12, 2, 40, 40)];
    [profilePicture sd_setImageWithURL:[NSURL URLWithString:self.hairfie.author.thumbUrl] placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];


    UIButton *usernameButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 0, 160, 30)];
    [usernameButton addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
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
    detailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [collectionHeaderView addSubview:hairfieView];
    [collectionHeaderView addSubview:hairfieDetailView];
    [collectionHeaderView addSubview:detailsTableView];

    return collectionHeaderView;
}

-(IBAction)showProfile:(id)sender
{
    [self performSegueWithIdentifier:@"showUserProfile" sender:self];
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
    } else if ([segue.identifier isEqualToString:@"showUserProfile"]) {
        UserProfileViewController *userProfile = [segue destinationViewController];
        [userProfile setUser:self.hairfie.author];
        userProfile.isCurrentUser = NO;
    }
}

@end
