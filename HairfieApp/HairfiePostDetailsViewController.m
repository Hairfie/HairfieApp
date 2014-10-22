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

#import <LoopBack/LoopBack.h>

#define OVERLAY_TAG 99


@implementation HairfiePostDetailsViewController
{
    NSMutableArray *salonTypes;
    Picture *uploadedPicture;
    BOOL uploadInProgress;
    AppDelegate *appDelegate;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad
{
    UIColor *placeholder = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_emailTextField setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    _hairfieImageView.image = _hairfiePost.picture.image;

    _hairfieDesc.alpha = 0.5;
    _hairfieDesc.placeholder = NSLocalizedStringFromTable(@"Add a description", @"Post_Hairfie", nil);

    _dataChoice.hidden = YES;
    _dataChoice.layer.borderWidth = 1;
    _dataChoice.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_dataChoice setSeparatorInset:UIEdgeInsetsZero];

    _isSalon = NO;
    _isHairdresser = NO;
    _hairdresserSubview.hidden = YES;
    _emailSubview.hidden = YES;

    salonTypes = [[NSMutableArray alloc] initWithObjects:NSLocalizedStringFromTable(@"I did it", @"Post_Hairfie", nil), NSLocalizedStringFromTable(@"Hairdresser in a Salon", @"Post_Hairfie", nil), nil];
    _tableViewHeight.constant = [salonTypes count] * _dataChoice.rowHeight;
    [_priceTextField textFieldWithPhoneKeyboard];

    [self uploadHairfiePicture];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (appDelegate.currentUser.managedBusinesses.count != 0)
    {
        if (salonTypes.count == 2) {
            for (Business *business in appDelegate.currentUser.managedBusinesses)
            {
                [salonTypes insertObject:business atIndex:1];
            }
        }
        _tableViewHeight.constant = salonTypes.count * _dataChoice.rowHeight;
    }
    if(_salonChosen != nil) {
        _hairfiePost.business = _salonChosen;
    }
    
    if (_hairfiePost.business != nil) {
        [_salonLabelButton setTitle:_hairfiePost.business.name forState:UIControlStateNormal];
        _hairdresserSubview.hidden = NO;
    }
    [ARAnalytics pageView:@"AR - Post Hairfie step #3 - Post Detail"];
}

- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showSalonsChoices:(id)sender
{
    [_hairfieDesc resignFirstResponder];
    if (_isSalon == YES) {
        _dataChoice.hidden = YES;
        _isSalon = NO;
    } else {
        
        CGFloat ypos = _dataChoice.rowHeight * salonTypes.count;
        [_tableViewHeight setConstant:ypos];
        NSLog(@"%f , %f, %ld", _tableViewHeight.constant, _dataChoice.rowHeight, salonTypes.count);
        _salonOrHairdresser = YES;
        [_dataChoice reloadData];
        _dataChoice.hidden = NO;
        _isSalon = YES;
    }
}

-(IBAction)showHairdresserChoices:(id)sender
{
    [_hairfieDesc resignFirstResponder];
    if (_isHairdresser == YES) {
        _dataChoice.hidden = YES;
        _isHairdresser = NO;
    } else {
        _tableViewYPos.constant = 268;
        _salonOrHairdresser = NO;
        [_dataChoice reloadData];
        _dataChoice.hidden = NO;
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
    return salonTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (_salonOrHairdresser == YES)
    {
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
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Hairdresser %ld", indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == salonTypes.count - 1)
    {
        [self performSegueWithIdentifier:@"choseSalonType" sender:self];
        [self showSalonsChoices:self];
    }
    else if (indexPath.row == 0)
    {
        [_salonLabelButton setTitle:@"I did it" forState:UIControlStateNormal];
        [self showSalonsChoices:self];
    }
    else
    {
        
        Business *business = [salonTypes objectAtIndex:indexPath.row];
         [_salonLabelButton setTitle:business.name forState:UIControlStateNormal];
        _salonChosen = business;
        [self showSalonsChoices:self];
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

        if(![_hairfiePost pictureIsUploaded]) {
            [self removeSpinnerAndOverlay];
            [self showUploadFailedAlertView];
            return; 
        }

        _hairfiePost.description = self.hairfieDesc.text;
        _hairfiePost.hairdresserName = self.whoTextField.text;

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
        void (^loadSuccessBlock)(void) = ^(void){
            NSLog(@"Hairfie Posté");
            [self removeSpinnerAndOverlay];
            [self performSegueWithIdentifier:@"toHome" sender:self];
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

-(void) uploadHairfiePicture {
    uploadInProgress = YES;
    
    [_hairfiePost uploadPictureWithSuccess:^{
        NSLog(@"Uploaded !");
        uploadInProgress = NO;
    } failure:^(NSError *error) {
        uploadInProgress = NO;
        NSLog(@"Error : %@", error.description);
    }];
}


-(void)showUploadFailedAlertView {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedStringFromTable(@"There was an error uploading your hairfie, Try Again !", @"Post_Hairfie", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self uploadHairfiePicture];
}


-(IBAction)fbShare:(id)sender {
    
}


@end

