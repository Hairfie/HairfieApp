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

#define OVERLAY_TAG 99


@implementation HairfiePostDetailsViewController
{
    NSMutableArray *salonTypes;
    NSMutableArray *salonHairdressers;
    Picture *uploadedPicture;
    BOOL uploadInProgress;
    BOOL isFbShareActivated;
    AppDelegate *appDelegate;
    BOOL isLoaded;
}

-(void)viewDidLoad
{

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUploadStatus:) name:@"firstPicUploaded" object:nil];
    //// TAGS = NO DESCRIPTION
    _hairfieDesc.hidden = YES;
    ////
    
    isLoaded = NO;
    UIColor *placeholder = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_emailTextField setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    Picture *hairfiePic  = [self.hairfiePost.pictures objectAtIndex:0];
    
    _hairfieImageView.image = hairfiePic.image;

    _hairfieDesc.alpha = 0.5;
    _hairfieDesc.placeholder = NSLocalizedStringFromTable(@"Add a description", @"Post_Hairfie", nil);

    _dataChoice.hidden = YES;
    _dataChoice.layer.borderWidth = 1;
    _dataChoice.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_dataChoice setSeparatorInset:UIEdgeInsetsZero];

    
    _hairdresserTableView.hidden = YES;
    _hairdresserTableView.layer.borderWidth = 1;
    _hairdresserTableView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_hairdresserTableView setSeparatorInset:UIEdgeInsetsZero];
    
    _isSalon = NO;
    _isHairdresser = NO;
     _emailSubview.hidden = YES;

    
    _tagsButton.layer.cornerRadius = 5;
    _tagsButton.layer.masksToBounds = YES;
    salonTypes = [[NSMutableArray alloc] initWithObjects:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil), NSLocalizedStringFromTable(@"Hairdresser in a Salon", @"Post_Hairfie", nil), nil];

    [_priceTextField textFieldWithPhoneKeyboard];
    [_descView addBottomBorderWithHeight:3 andColor:[UIColor salonDetailTab]];
    [_topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
    [self uploadHairfiePictures];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.hairfiePost.customerEmail.length != 0)
    {
        [self.emailLabel setText:self.hairfiePost.customerEmail ];
    }
    else
    {
        [self.emailLabel setText:NSLocalizedStringFromTable(@"add email hairfie", @"Post_Hairfie", nil)];
    }
    if (self.hairfiePost.tags.count != 0)
    {
        self.tagsButton.hidden = NO;
        NSString *tagLabel = [NSString stringWithFormat:@"(%zd) tags", self.hairfiePost.tags.count];
        [self.tagsButton setTitle:tagLabel forState:UIControlStateNormal];
    }
    else {
        self.tagsButton.hidden = YES;
    }
    
    if (appDelegate.currentUser.managedBusinesses.count != 0)
    {
        if (salonTypes.count == 2) {
            for (Business *business in appDelegate.currentUser.managedBusinesses)
            {
                [salonTypes insertObject:business atIndex:1];
            }
        }
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        int height = cell.frame.size.height ;
        _salonTableViewHeight.constant = salonTypes.count * height;
        
        if (isLoaded == NO) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.dataChoice selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        _isSalon = YES;
        [self tableView:self.dataChoice didSelectRowAtIndexPath:indexPath];
            isLoaded = YES;
        }
    }
    if(_salonChosen != nil) {
        _hairfiePost.business = _salonChosen;
        if ([_hairfiePost.business.activeHairdressers count] != 0)
            [self loadHairdressers];
        _isSalon = YES;
        [_salonLabelButton setTitle:_hairfiePost.business.name forState:UIControlStateNormal];
    }

    [self refreshTwitterShareButton];

    [ARAnalytics pageView:@"AR - Post Hairfie step #3 - Post Detail"];
}

-(void)loadHairdressers
{
    salonHairdressers = [[NSMutableArray alloc] init];
   
    for (Hairdresser *hairdresser in _hairfiePost.business.activeHairdressers)
    {
        [salonHairdressers addObject:hairdresser];
    }
    _hairdresserTableViewHeight.constant = [salonHairdressers count] * 41;
    _isHairdresser = NO;
    [_hairdresserTableView reloadData];
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
    if (_isSalon == YES) {
        _dataChoice.hidden = YES;
        _isSalon = NO;
    } else {
    
        [_dataChoice reloadData];
        _dataChoice.hidden = NO;
        _isHairdresser = NO;
        _hairdresserTableView.hidden = YES;
        _isSalon = YES;
    }
}

-(IBAction)showHairdresserChoices:(id)sender
{
    if (_isHairdresser == YES) {
        _hairdresserTableView.hidden = YES;
        _isHairdresser = NO;
    } else {
        [_hairdresserTableView reloadData];
        _isSalon = NO;
        _hairdresserTableView.hidden = NO;
        _isHairdresser = YES;
    }
     
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _hairfieDesc)
    {
        _hairfieDesc.placeholder = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == _hairfieDesc)
    {
        _hairfieDesc.placeholder = NSLocalizedStringFromTable(@"Add a description", @"Post_Hairfie", nil);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _dataChoice)
        return salonTypes.count;
    if (tableView == _hairdresserTableView)
        return salonHairdressers.count;
    
    return 1;
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
        
        Hairdresser *hairdresser = [salonHairdressers objectAtIndex:indexPath.row];
        cell.textLabel.text = [hairdresser displayFullName];
    }
    else {
   
        if (indexPath.row == salonTypes.count - 1)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([[salonTypes objectAtIndex:indexPath.row] isKindOfClass:[Business class]])
        {
            Business *business = [salonTypes objectAtIndex:indexPath.row];
            cell.textLabel.text = business.name;
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
    if (tableView == _dataChoice)
    {
    if (indexPath.row == salonTypes.count - 1)
    {
        [self performSegueWithIdentifier:@"choseSalonType" sender:self];
        [self showSalonsChoices:self];
        _hairfiePost.selfMade = NO;
    }
    else if (indexPath.row == 0)
    {
        [_salonLabelButton setTitle:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil) forState:UIControlStateNormal];
        [self showSalonsChoices:self];
        _hairdresserSubview.hidden = YES;
        _hairfiePost.selfMade = YES;
    }
    else
    {
        Business *business = [salonTypes objectAtIndex:indexPath.row];
         [_salonLabelButton setTitle:business.name forState:UIControlStateNormal];
        _hairfiePost.business = business;
        if (business.activeHairdressers.count != 0) {
            [self loadHairdressers];
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
    }
    else
    {
        Hairdresser *hairdresser = [salonHairdressers objectAtIndex:indexPath.row];
        [_hairdresserLabelButton setTitle:[hairdresser displayFullName] forState:UIControlStateNormal];
        _hairfiePost.hairdresser = hairdresser;
        [self showHairdresserChoices:self];
    }
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
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([delegate.credentialStore isLoggedIn]) {

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

            _hairfiePost.price = price;
        }

        if (self.salonChosen) {
            _hairfiePost.business = self.salonChosen;
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
        };
        [_hairfiePost saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    } else {
        [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
    }
}

-(void) addSpinnerAndOverlay {
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

-(void) removeSpinnerAndOverlay {
    [[_mainView viewWithTag:OVERLAY_TAG] removeFromSuperview];
}

-(void)changeUploadStatus:(NSNotification*)notification
{
    uploadInProgress = NO;
}

-(void) uploadHairfiePictures {
    uploadInProgress = YES;

    [_hairfiePost uploadPictureWithSuccess:^{
        NSLog(@"Uploaded !");
        uploadInProgress = NO;
    } failure:^(NSError *error) {
        uploadInProgress = NO;
        NSLog(@"Error HAIRFIE: %@", error.description);
    }];
}


-(void)showUploadFailedAlertView {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedStringFromTable(@"There was an error uploading your hairfie, Try Again !", @"Post_Hairfie", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self uploadHairfiePictures];
}


-(IBAction)fbShare:(id)sender {
    
    if(isFbShareActivated) {
        [sender setImage:[UIImage imageNamed:@"fb-share-off.png"] forState:UIControlStateNormal];
        isFbShareActivated = NO;
        _hairfiePost.shareOnFB = NO;
    } else {
        [self checkFbSessionWithSuccess:^{
            NSArray *permissionsNeeded = @[@"publish_actions"];
            [FBUtils getPermissions:permissionsNeeded success:^{
                NSLog(@"GOGO Share !");
                [sender setImage:[UIImage imageNamed:@"fb-share-on.png"] forState:UIControlStateNormal];
                isFbShareActivated = YES;
                _hairfiePost.shareOnFB = YES;
            } failure:^(NSError *error) {
                NSLog(@"Sharing failed !");
            }];
        } failure:^(NSError *error) {
            NSLog(@"Sharing failed !");
        }];
    }
}

-(IBAction)twitterShare:(id)sender
{
    if (!self.hairfiePost.shareOnTwitter) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            NSString *message = NSLocalizedStringFromTable(@"It seems that we cannot talk to Twitter at the moment or you have not yet added your Twitter account to this device.", @"Hairfie_Detail", nil);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            self.hairfiePost.shareOnTwitter = YES;
        }
    } else {
        self.hairfiePost.shareOnTwitter = NO;
    }

    [self refreshTwitterShareButton];
}

-(void)refreshTwitterShareButton
{
    if (self.hairfiePost.shareOnTwitter) {
        [self.twitterShareButton setImage:[UIImage imageNamed:@"twitter-share-on"] forState:UIControlStateNormal];
    } else {
        [self.twitterShareButton setImage:[UIImage imageNamed:@"twitter-share-off"] forState:UIControlStateNormal];
    }
}

-(IBAction)setHairfieEmail:(id)sender
{
    [self performSegueWithIdentifier:@"postHairfieEmail" sender:self];
}

-(void)checkFbSessionWithSuccess:(void(^)())aSuccessHandler
                         failure:(void(^)(NSError *error))aFailureHandler {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        aSuccessHandler();
    } else {
        FBAuthenticator *fbAuthenticator = [[FBAuthenticator alloc] init];
        [fbAuthenticator linkFbAccountWithPermissions:@[@"publish_actions"] success:aSuccessHandler failure:aFailureHandler];
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

