//
//  HairfiePostDetailsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostDetailsViewController.h"
#import "HairfieUploader.h"
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
    BOOL isLoaded;

}


@synthesize appDelegate;
-(void)viewDidLoad
{
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segueToHome:) name:@"toHome" object:nil];
    //// TAGS = NO DESCRIPTION
    self.hairfieDesc.hidden = YES;
    ////

    
    
    [self.emailTextField setValue:[[UIColor whiteColor] colorWithAlphaComponent:0.6]
                       forKeyPath:@"_placeholderLabel.textColor"];
    

    // setup images
    

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
    self.emailSubview.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    self.emailSubview.layer.borderWidth = 1;
    self.emailSubview.layer.cornerRadius = 2.5;
    self.emailSubview.layer.masksToBounds = YES;

    self.priceSubview.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    self.priceSubview.layer.borderWidth = 1;
    self.priceSubview.layer.cornerRadius = 2.5;
    self.priceSubview.layer.masksToBounds = YES;

    self.tagsButton.layer.cornerRadius = 5;
    self.tagsButton.layer.masksToBounds = YES;

    salonTypes = [[NSMutableArray alloc] initWithObjects:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil), NSLocalizedStringFromTable(@"Hairdresser in a Salon", @"Post_Hairfie", nil), nil];

    [self.priceTextField textFieldWithPhoneKeyboard:(self.view.frame.size.width / 2 - 50)];
    [self.topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.hairfieImageView.image = [[appDelegate.hairfieUploader.hairfiePost mainPicture] image];
    if ([appDelegate.hairfieUploader.hairfiePost hasSecondaryPicture]) {
        self.secondHairfieImageView.image = [[appDelegate.hairfieUploader.hairfiePost secondaryPicture] image];
        self.secondHairfieImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.secondHairfieImageView.layer.borderWidth = 1;
    }
    else {
        self.secondHairfieImageView.hidden = YES;
    }
    
    // customer email field
    if (appDelegate.hairfieUploader.hairfiePost.customerEmail.length != 0) {
        self.emailLabel.text = appDelegate.hairfieUploader.hairfiePost.customerEmail;
    } else {
        self.emailLabel.text = NSLocalizedStringFromTable(@"add email hairfie", @"Post_Hairfie", nil);
    }

    // selected tags count
    if (appDelegate.hairfieUploader.hairfiePost.tags.count != 0) {
        self.tagsButton.hidden = NO;
        NSString *tagLabel = [NSString stringWithFormat:@"(%zd) tags", appDelegate.hairfieUploader.hairfiePost.tags.count];
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
        
        if (appDelegate.hairfieUploader.hairfiePost.business == nil) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.dataChoice selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.isSalon = YES;
            [self tableView:self.dataChoice didSelectRowAtIndexPath:indexPath];
        }
    }

    if (appDelegate.hairfieUploader.hairfiePost.business != nil) {
        if ([appDelegate.hairfieUploader.hairfiePost.business.activeHairdressers count] != 0) {
            [self loadBusinessMembers];
        }
        self.isSalon = YES;
        [self.salonLabelButton setTitle:appDelegate.hairfieUploader.hairfiePost.business.name forState:UIControlStateNormal];

    }

    [self refreshShareButtons];

    [ARAnalytics pageView:@"AR - Post Hairfie step #3 - Post Detail"];
}

-(void)loadBusinessMembers
{
    salonBusinessMembers = [[NSMutableArray alloc] init];
   
    for (BusinessMember *hairdresser in appDelegate.hairfieUploader.hairfiePost.business.activeHairdressers) {
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
    appDelegate.hairfieUploader.hairfiePost.shareOnFacebook = NO;
    appDelegate.hairfieUploader.hairfiePost.shareOnFacebookPage = NO;
    appDelegate.hairfieUploader.hairfiePost.shareOnTwitter = NO;
    
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
            appDelegate.hairfieUploader.hairfiePost.selfMade = NO;
        } else if (indexPath.row == 0) {
            [_salonLabelButton setTitle:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil) forState:UIControlStateNormal];
            appDelegate.hairfieUploader.hairfiePost.business = nil;
            [self showSalonsChoices:self];
            _hairdresserSubview.hidden = YES;
            appDelegate.hairfieUploader.hairfiePost.selfMade = YES;
        } else {
            Business *business = [salonTypes objectAtIndex:indexPath.row];
             [_salonLabelButton setTitle:business.name forState:UIControlStateNormal];
            appDelegate.hairfieUploader.hairfiePost.business = business;
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
            appDelegate.hairfieUploader.hairfiePost.selfMade = NO;
        }
        
        [self refreshShareButtons];
    } else {
        BusinessMember *businessMember = [salonBusinessMembers objectAtIndex:indexPath.row];
        [_hairdresserLabelButton setTitle:[businessMember displayFullName] forState:UIControlStateNormal];
        appDelegate.hairfieUploader.hairfiePost.businessMember = businessMember;
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
    
    appDelegate.hairfieUploader.hairfiePost.description = self.hairfieDesc.text;
    
    if (![self.priceTextField.text isEqualToString:@""]) {
        Money *price = [[Money alloc] initWithAmount:[NSNumber numberWithDouble:[self.priceTextField.text doubleValue]]
                                            currency:@"EUR"];
        
        appDelegate.hairfieUploader.hairfiePost.price = price;
    }
    
//    if (self.hairfiePost.shareOnTwitter) {
//        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [vc addURL:hairfie.landingPageUrl];
//        vc.completionHandler = ^(SLComposeViewControllerResult result) {
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"toHome" object:nil];
//        };
//        
//         [self presentViewController:vc animated:YES completion:nil];
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"toHome" object:nil];
//    }
//
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [appDelegate.hairfieUploader postHairfie];
    });
    
    [self performSegueWithIdentifier:@"toHome" sender:self];
}

-(void)segueToHome:(NSNotification*)notification
{
    [self performSegueWithIdentifier:@"toHome" sender:self];
}


-(IBAction)switchFacebookShare:(id)sender
{
    if (appDelegate.hairfieUploader.hairfiePost.shareOnFacebook) {
        appDelegate.hairfieUploader.hairfiePost.shareOnFacebook = NO;
        [self refreshShareButtons];
    } else {
        // prior to activate facebook share, we need to get user's permission
        [self checkFacebookPermissions:@[@"publish_actions"]
                           withSuccess:^{
                               NSLog(@"Got facebook permissions");
                               appDelegate.hairfieUploader.hairfiePost.shareOnFacebook = YES;
                               [self refreshShareButtons];
                           }
                               failure:^(NSError *error) {
                                   NSLog(@"Failed to get facebook permissions: %@", error.localizedDescription);
                               }];
    }
}

-(IBAction)switchFacebookPageShare:(id)sender
{
    appDelegate.hairfieUploader.hairfiePost.shareOnFacebookPage = !appDelegate.hairfieUploader.hairfiePost.shareOnFacebookPage;
    [self refreshShareButtons];
}

-(IBAction)switchTwitterShare:(id)sender
{
    if (appDelegate.hairfieUploader.hairfiePost.shareOnTwitter) {
        appDelegate.hairfieUploader.hairfiePost.shareOnTwitter = NO;
    } else {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            appDelegate.hairfieUploader.hairfiePost.shareOnTwitter = YES;
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
        appDelegate.hairfieUploader.hairfiePost.shareOnFacebookPage = NO;
    }
    
    if (appDelegate.hairfieUploader.hairfiePost.shareOnFacebook) {
        [self.facebookShareButton setImage:[UIImage imageNamed:@"facebook-share-on"] forState:UIControlStateNormal];
    } else {
        [self.facebookShareButton setImage:[UIImage imageNamed:@"facebook-share-off"] forState:UIControlStateNormal];
    }
    
    if (appDelegate.hairfieUploader.hairfiePost.shareOnFacebookPage) {
        [self.facebookPageShareButton setImage:[UIImage imageNamed:@"facebook-page-share-on"] forState:UIControlStateNormal];
    } else {
        [self.facebookPageShareButton setImage:[UIImage imageNamed:@"facebook-page-share-off"] forState:UIControlStateNormal];
    }
    
    if (appDelegate.hairfieUploader.hairfiePost.shareOnTwitter) {
        [self.twitterShareButton setImage:[UIImage imageNamed:@"twitter-share-on"] forState:UIControlStateNormal];
    } else {
        [self.twitterShareButton setImage:[UIImage imageNamed:@"twitter-share-off"] forState:UIControlStateNormal];
    }
}

-(BOOL)canShareOnFacebookPage
{
    return [appDelegate.hairfieUploader.hairfiePost.business isFacebookPageShareEnabled]
        && [self currentUserIsManagerOfBusiness:appDelegate.hairfieUploader.hairfiePost.business];
}

-(BOOL)hasForgottenCustomerEmail
{
    return !appDelegate.hairfieUploader.hairfiePost.customerEmail
    && [self currentUserIsManagerOfBusiness:appDelegate.hairfieUploader.hairfiePost.business];
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

        
    }
    if ([segue.identifier isEqualToString:@"postHairfieEmail"])
    {

    }
}

@end

