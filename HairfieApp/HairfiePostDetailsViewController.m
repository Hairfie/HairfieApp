//
//  HairfiePostDetailsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostDetailsViewController.h"
#import "Picture.h"
#import "AppDelegate.h"
#import "Business.h"
#import "Money.h"
#import "NotLoggedAlert.h"
#import "UITextField+Style.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBUtils.h"
#import "FBAuthenticator.h"
#import "UIView+Borders.h"
#import "AddTagsToHairfieViewController.h"
#import "PostHairfieEmailViewController.h"
#import <LoopBack/LoopBack.h>
#import <Social/Social.h>
#import <UIAlertView+Blocks.h>

#define OVERLAY_TAG 99


@implementation HairfiePostDetailsViewController
{
    NSMutableArray *salonTypes;
    NSMutableArray *salonBusinessMembers;
    Picture *uploadedPicture;
    BOOL uploadInProgress;
    AppDelegate *appDelegate;
    BOOL isLoaded;
}

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUploadStatus:) name:@"firstPicUploaded" object:nil];
    
    //// TAGS = NO DESCRIPTION
    self.hairfieDesc.hidden = YES;
    ////

    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.emailTextField setValue:[[UIColor whiteColor] colorWithAlphaComponent:0.6]
                       forKeyPath:@"_placeholderLabel.textColor"];
    

    // setup images
    self.hairfieImageView.image = [[self.hairfiePost mainPicture] image];
    if ([self.hairfiePost hasSecondaryPicture]) {
        self.secondHairfieImageView.image = [[self.hairfiePost secondaryPicture] image];
    }

    self.dataChoice.hidden = YES;
    self.dataChoice.layer.borderWidth = 1;
    self.dataChoice.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [self.dataChoice setSeparatorInset:UIEdgeInsetsZero];
    
    self.hairdresserTableView.hidden = YES;
    self.hairdresserTableView.layer.borderWidth = 1;
    self.hairdresserTableView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [self.hairdresserTableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.isSalon = NO;
    self.isHairdresser = NO;
    self.emailSubview.hidden = YES;
    
    self.tagsButton.layer.cornerRadius = 5;
    self.tagsButton.layer.masksToBounds = YES;

    salonTypes = [[NSMutableArray alloc] initWithObjects:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil), NSLocalizedStringFromTable(@"Hairdresser in a Salon", @"Post_Hairfie", nil), nil];

    [self.priceTextField textFieldWithPhoneKeyboard];
    [self.topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];

    [self uploadHairfiePictures];
}

-(void)viewWillAppear:(BOOL)animated
{
    // customer email field
    if (self.hairfiePost.customerEmail.length != 0) {
        self.emailLabel.text = self.hairfiePost.customerEmail;
    } else {
        self.emailLabel.text = NSLocalizedStringFromTable(@"add email hairfie", @"Post_Hairfie", nil);
    }

    // selected tags count
    if (self.hairfiePost.tags.count != 0) {
        self.tagsButton.hidden = NO;
        NSString *tagLabel = [NSString stringWithFormat:@"(%zd) tags", self.hairfiePost.tags.count];
        [self.tagsButton setTitle:tagLabel forState:UIControlStateNormal];
    } else {
        self.tagsButton.hidden = YES;
    }

    // business selector
    if (appDelegate.currentUser.managedBusinesses.count != 0)
    {
        // NOTE: it is not managed businesses change proof!
        if (salonTypes.count == 2) {
            for (Business *business in appDelegate.currentUser.managedBusinesses) {
                [salonTypes insertObject:business atIndex:1];
            }
        }
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        int height = cell.frame.size.height ;
        self.salonTableViewHeight.constant = salonTypes.count * height;
        
        if (self.hairfiePost.business == nil) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.dataChoice selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.isSalon = YES;
            [self tableView:self.dataChoice didSelectRowAtIndexPath:indexPath];
        }
    }

    if (self.hairfiePost.business != nil) {
        if ([self.hairfiePost.business.activeHairdressers count] != 0) {
            [self loadBusinessMembers];
        }
        self.isSalon = YES;
        [self.salonLabelButton setTitle:self.hairfiePost.business.name forState:UIControlStateNormal];
    }

    [self refreshShareButtons];

    [ARAnalytics pageView:@"AR - Post Hairfie step #3 - Post Detail"];
}

-(void)loadBusinessMembers
{
    salonBusinessMembers = [[NSMutableArray alloc] init];
   
    for (BusinessMember *hairdresser in _hairfiePost.business.activeHairdressers) {
        [salonBusinessMembers addObject:hairdresser];
    }
    
    self.hairdresserTableViewHeight.constant = MIN(4, salonBusinessMembers.count) * 41;

    self.isHairdresser = NO;
    
    [self.hairdresserTableView reloadData];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }

    return YES;
}

-(IBAction)goBack:(id)sender
{
    NSLog(@"BACK");
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addTags:(id)sender
{
    NSLog(@"TAGS");
    [self performSegueWithIdentifier:@"addTagsToHairfie" sender:self];
}

-(IBAction)showSalonsChoices:(id)sender
{
    if (self.isSalon == YES) {
        self.dataChoice.hidden = YES;
        self.isSalon = NO;
    } else {
        [self.dataChoice reloadData];
        CGRect frame = _dataChoice.frame;
        frame.size.height = 200;
        [self.dataChoice setFrame:frame];
        self.dataChoice.hidden = NO;
        self.isHairdresser = NO;
        self.hairdresserTableView.hidden = YES;
        self.isSalon = YES;
    }
}

-(IBAction)showHairdresserChoices:(id)sender
{
    if (self.isHairdresser == YES) {
        self.hairdresserTableView.hidden = YES;
        self.isHairdresser = NO;
    } else {
        [self.hairdresserTableView reloadData];
        self.isSalon = NO;
        self.hairdresserTableView.hidden = NO;
        self.isHairdresser = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.dataChoice) {
        return salonTypes.count;
    } else if (tableView == _hairdresserTableView) {
        return salonBusinessMembers.count;
    }

    return 1;
}

-(void)deselectShareButtons
{
    self.hairfiePost.shareOnFacebook = NO;
    self.hairfiePost.shareOnFacebookPage = NO;
    self.hairfiePost.shareOnTwitter = NO;
    
    [self refreshShareButtons];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    cell.textLabel.textColor =
    [UIColor colorWithRed:191/255.0f green:194/255.0f blue:199/255.0f alpha:1];
  
    if (tableView == self.hairdresserTableView)
    {
        BusinessMember *businessMember = [salonBusinessMembers objectAtIndex:indexPath.row];
        cell.textLabel.text = [businessMember displayFullName];
    }
    else {
   
        if (indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == salonTypes.count - 1)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([[salonTypes objectAtIndex:indexPath.row] isKindOfClass:[Business class]])
        {
            Business *business = [salonTypes objectAtIndex:indexPath.row];
            cell.textLabel.text = business.name;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
            cell.textLabel.text = [salonTypes objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
            cell.textLabel.textColor =
            [UIColor colorWithRed:191/255.0f green:194/255.0f blue:199/255.0f alpha:1];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectShareButtons];
    if (tableView == _dataChoice) {
        if (indexPath.row == salonTypes.count - 1) {
            [self performSegueWithIdentifier:@"choseSalonType" sender:self];
            [self showSalonsChoices:self];
            _hairfiePost.selfMade = NO;
        } else if (indexPath.row == 0) {
            [_salonLabelButton setTitle:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil) forState:UIControlStateNormal];
            _hairfiePost.business = nil;
            [self showSalonsChoices:self];
            _hairdresserSubview.hidden = YES;
            _hairfiePost.selfMade = YES;
        } else {
            Business *business = [salonTypes objectAtIndex:indexPath.row];
             [_salonLabelButton setTitle:business.name forState:UIControlStateNormal];
            _hairfiePost.business = business;
            if (business.activeHairdressers.count != 0) {
                [self loadBusinessMembers];
                [_hairdresserLabelButton setTitle:NSLocalizedStringFromTable(@"Who did this?", @"Post_Hairfie", nil) forState:UIControlStateNormal];
            }
            else {
                [_hairdresserLabelButton setTitle:NSLocalizedStringFromTable(@"No Hairdresser in this salon", @"Post_Hairfie", nil) forState:UIControlStateNormal];
                _hairdresserTableViewHeight.constant = 0;
            }
            _hairdresserSubview.hidden = NO;
            [self showSalonsChoices:self];
            _hairfiePost.selfMade = NO;
        }
        
        [self refreshShareButtons];
    } else {
        BusinessMember *businessMember = [salonBusinessMembers objectAtIndex:indexPath.row];
        [_hairdresserLabelButton setTitle:[businessMember displayFullName] forState:UIControlStateNormal];
        _hairfiePost.businessMember = businessMember;
        [self showHairdresserChoices:self];
    }
}

-(BOOL)currentUserIsManagerOfBusiness:(Business *)aBusiness
{
    for (int i = 0; i < appDelegate.currentUser.managedBusinesses.count; i++) {
        Business *business = [appDelegate.currentUser.managedBusinesses objectAtIndex:i];
        if (aBusiness.id == business.id) {
            return YES;
        }
    }

    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)postHairfie:(id)sender
{
    if([appDelegate.credentialStore isLoggedIn]) {
        if([self hasForgottenCustomerEmail]) {
            [UIAlertView showWithTitle:NSLocalizedStringFromTable(@"No customer email", @"Post_Hairfie", nil)
                               message:NSLocalizedStringFromTable(@"You forgot to enter a customer email", @"Post_Hairfie", nil)
                     cancelButtonTitle:NSLocalizedStringFromTable(@"Add email", @"Post_Hairfie", nil)
                     otherButtonTitles:@[NSLocalizedStringFromTable(@"Continue anyway", @"Post_Hairfie", nil)]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if (buttonIndex == [alertView cancelButtonIndex]) {
                                      NSLog(@"Cancelled");
                                      [self performSegueWithIdentifier:@"postHairfieEmail" sender:self];
                                  } else {
                                      NSLog(@"Continue anyway");
                                      [self saveHairfiePost];
                                  }
                              }];
        } else {
            [self saveHairfiePost];
        }

    } else {
        [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
    }
}

-(void)saveHairfiePost {
    
    [self addSpinnerAndOverlay];
    
    NSLog(@"Post Hairfie");
    while (uploadInProgress) {
        NSLog(@"---------- Upload in progress ----------");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    NSLog(@"isuploaded %c", [_hairfiePost pictureIsUploaded]);
    if(![_hairfiePost pictureIsUploaded]) {
        [self removeSpinnerAndOverlay];
        [self showUploadFailedAlertView];
        return;
    }
    
    _hairfiePost.description = self.hairfieDesc.text;
    
    if (![self.priceTextField.text isEqualToString:@""]) {
        Money *price = [[Money alloc] initWithAmount:[NSNumber numberWithDouble:[self.priceTextField.text doubleValue]]
                                            currency:@"EUR"];
        
        self.hairfiePost.price = price;
    }
    
    NSLog(@"Hairfie to post : %@", _hairfiePost);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        [self removeSpinnerAndOverlay];
        [self showUploadFailedAlertView];
        
    };
    void (^loadSuccessBlock)(Hairfie *) = ^(Hairfie *hairfie){
        NSLog(@"Hairfie Posté");
        [self removeSpinnerAndOverlay];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
        
        if (self.hairfiePost.shareOnTwitter) {
            SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [vc addURL:hairfie.landingPageUrl];
            vc.completionHandler = ^(SLComposeViewControllerResult result) {
                [self performSegueWithIdentifier:@"toHome" sender:self];
            };
            
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [self performSegueWithIdentifier:@"toHome" sender:self];
        }
        HairfieNotifications *notif = [HairfieNotifications new];
        [notif showNotificationWithMessage:NSLocalizedStringFromTable(@"Hairfie Post Successful", @"Post_Hairfie", nil) ForDuration:2.5];
    };
    [_hairfiePost saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    
}

-(void)addSpinnerAndOverlay
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner setFrame:CGRectMake(150, self.view.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height)];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];

    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(80, self.view.frame.size.height/2 + 20, 140, 50)];
    text.text = NSLocalizedStringFromTable(@"Upload in progress", @"Post_Hairfie", nil);
    text.font = [UIFont fontWithName:@"SourceSansPro-Light" size:16];
    [text setTextColor:[UIColor whiteColor]];
    [text setTextAlignment:NSTextAlignmentCenter];

    UIView *overlay = [[UIView alloc] initWithFrame:_mainView.frame];
    overlay.backgroundColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.6];

    [overlay addSubview:spinner];
    [overlay addSubview:text];

    [overlay setTag:OVERLAY_TAG];
    [_mainView addSubview:overlay];
}

-(void)removeSpinnerAndOverlay
{
    [[_mainView viewWithTag:OVERLAY_TAG] removeFromSuperview];
}

-(void)changeUploadStatus:(NSNotification*)notification
{
    uploadInProgress = NO;
}

-(void) uploadHairfiePictures
{
    uploadInProgress = YES;
    [_hairfiePost uploadPictureWithSuccess:^{
        NSLog(@"Uploaded !");
        uploadInProgress = NO;
    } failure:^(NSError *error) {
        uploadInProgress = NO;
        NSLog(@"Error HAIRFIE: %@", error.description);
    }];
}

-(void)showUploadFailedAlertView
{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedStringFromTable(@"There was an error uploading your hairfie, Try Again !", @"Post_Hairfie", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self uploadHairfiePictures];
}

-(IBAction)switchFacebookShare:(id)sender
{
    if (self.hairfiePost.shareOnFacebook) {
        self.hairfiePost.shareOnFacebook = NO;
        [self refreshShareButtons];
    } else {
        // prior to activate facebook share, we need to get user's permission
        [self checkFacebookPermissions:@[@"publish_actions"]
                           withSuccess:^{
                               NSLog(@"Got facebook permissions");
                               self.hairfiePost.shareOnFacebook = YES;
                               [self refreshShareButtons];
                           }
                               failure:^(NSError *error) {
                                   NSLog(@"Failed to get facebook permissions: %@", error.localizedDescription);
                               }];
    }
}

-(IBAction)switchFacebookPageShare:(id)sender
{
    self.hairfiePost.shareOnFacebookPage = !self.hairfiePost.shareOnFacebookPage;
    [self refreshShareButtons];
}

-(IBAction)switchTwitterShare:(id)sender
{
    if (self.hairfiePost.shareOnTwitter) {
        self.hairfiePost.shareOnTwitter = NO;
    } else {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            self.hairfiePost.shareOnTwitter = YES;
        } else {
            NSString *message = NSLocalizedStringFromTable(@"It seems that we cannot talk to Twitter at the moment or you have not yet added your Twitter account to this device.", @"Hairfie_Detail", nil);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    [self refreshShareButtons];
}

-(void)refreshShareButtons
{
    if ([self canShareOnFacebookPage]) {
        self.facebookPageShareButton.hidden = NO;
    } else {
        self.facebookPageShareButton.hidden = YES;
        self.hairfiePost.shareOnFacebookPage = NO;
    }
    
    if (self.hairfiePost.shareOnFacebook) {
        [self.facebookShareButton setImage:[UIImage imageNamed:@"facebook-share-on"] forState:UIControlStateNormal];
    } else {
        [self.facebookShareButton setImage:[UIImage imageNamed:@"facebook-share-off"] forState:UIControlStateNormal];
    }
    
    if (self.hairfiePost.shareOnFacebookPage) {
        [self.facebookPageShareButton setImage:[UIImage imageNamed:@"facebook-page-share-on"] forState:UIControlStateNormal];
    } else {
        [self.facebookPageShareButton setImage:[UIImage imageNamed:@"facebook-page-share-off"] forState:UIControlStateNormal];
    }
    
    if (self.hairfiePost.shareOnTwitter) {
        [self.twitterShareButton setImage:[UIImage imageNamed:@"twitter-share-on"] forState:UIControlStateNormal];
    } else {
        [self.twitterShareButton setImage:[UIImage imageNamed:@"twitter-share-off"] forState:UIControlStateNormal];
    }
}

-(BOOL)canShareOnFacebookPage
{
    return [self.hairfiePost.business isFacebookPageShareEnabled]
        && [self currentUserIsManagerOfBusiness:self.hairfiePost.business];
}

-(BOOL)hasForgottenCustomerEmail
{
    return !self.hairfiePost.customerEmail
    && [self currentUserIsManagerOfBusiness:self.hairfiePost.business];
}

-(IBAction)setHairfieEmail:(id)sender
{
    [self performSegueWithIdentifier:@"postHairfieEmail" sender:self];
}

/**
 * TODO: move me into some facebook utility
 */
-(void)checkFacebookPermissions:(NSArray *)permissions
                    withSuccess:(void(^)())aSuccessHandler
                        failure:(void(^)(NSError *error))aFailureHandler
{
    void (^getPermissions)() = ^() {
        [FBUtils getPermissions:permissions
                        success:^{ aSuccessHandler(); }
                        failure:aFailureHandler];
    };
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        getPermissions();
    } else {
        FBAuthenticator *fbAuthenticator = [[FBAuthenticator alloc] init];
        [fbAuthenticator linkFbAccountWithPermissions:permissions
                                              success:getPermissions
                                              failure:aFailureHandler];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addTagsToHairfie"])
    {
        AddTagsToHairfieViewController *addTagsVc = [segue destinationViewController];
        
        addTagsVc.hairfiePost = self.hairfiePost;
        
    }
    if ([segue.identifier isEqualToString:@"postHairfieEmail"])
    {
        PostHairfieEmailViewController *postEmail = [segue destinationViewController];
    
        [postEmail setHairfiePost:self.hairfiePost];
    }
}

@end

