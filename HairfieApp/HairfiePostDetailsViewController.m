//
//  HairfiePostDetailsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostDetailsViewController.h"
#import "PictureUploader.h"
#import "AppDelegate.h"
#import "HairfieRepository.h"
#import "BusinessRepository.h"
#import "Business.h"
#import "NotLoggedAlert.h"

#import <LoopBack/LoopBack.h>

#define OVERLAY_TAG 99


@implementation HairfiePostDetailsViewController
{
    NSArray *salonTypes;
    NSString *uploadedFileName;
    BOOL uploadInProgress;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad
{
    UIColor *placeholder = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    [_emailTextField setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    _hairfieImageView.image= _hairfie;
    _hairfieDesc.alpha = 0.5;
    _dataChoice.hidden = YES;
    _dataChoice.layer.borderWidth = 1;
    _dataChoice.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_dataChoice setSeparatorInset:UIEdgeInsetsZero];
    _isSalon = NO;
    _isHairdresser = NO;
    _hairdresserSubview.hidden = YES;
    //_whoSubviewConstraint.constant = 0.f;
    _emailSubview.hidden = YES;
    salonTypes = [[NSArray alloc] initWithObjects:@"I did it", @"Hairdresser in a Salon", nil];
    _tableViewHeight.constant = [salonTypes count] * _dataChoice.rowHeight;
    [self addDoneButtonToPriceField];
    [self uploadHairfiePicture:_hairfie];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (_salonChosen != nil) {
        [_salonLabelButton setTitle:[_salonChosen objectForKeyedSubscript:@"name"] forState:UIControlStateNormal];
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
        _tableViewYPos.constant = 213;
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
    if (textView == _hairfieDesc && [_hairfieDesc.text isEqualToString:@"Add a description..."])
    {
        _hairfieDesc.text = @"";
        _hairfieDesc.alpha = 1;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == _hairfieDesc && [_hairfieDesc.text isEqualToString:@""])
    {
        _hairfieDesc.text = @"Add a description ...";
        _hairfieDesc.alpha = 0.5;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        if (indexPath.row != 0)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        cell.textLabel.text = [salonTypes objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
        cell.textLabel.textColor =
            [UIColor colorWithRed:191/255.0f green:194/255.0f blue:199/255.0f alpha:1];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Haidresser %ld", indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        [self performSegueWithIdentifier:@"choseSalonType" sender:self];
        [self showSalonsChoices:self];
    }
    else
    {
        [_salonLabelButton setTitle:@"I did it" forState:UIControlStateNormal];
        [self showSalonsChoices:self];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

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
        

        NSMutableDictionary *hairfieDic = [[NSMutableDictionary alloc] init];
        
        if(!uploadedFileName) {
            [self removeSpinnerAndOverlay];
            [self showUploadFailedAlertView];
            return; 
        }
                                           
        [hairfieDic setObject:uploadedFileName  forKey:@"picture"];
        [hairfieDic setObject:_hairfieDesc.text forKey:@"description"];

        if (_salonChosen){
            BusinessRepository *businessRepository = (BusinessRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[BusinessRepository class]];
            Business *business = (Business *)[businessRepository modelWithDictionary:_salonChosen];
            
            [hairfieDic setObject:business.id forKey:@"id"];
        }
        if (![_priceTextField.text isEqualToString:@""])
        {
            NSDictionary *price = [[NSDictionary alloc] initWithObjectsAndKeys:@"EUR", @"currency", _priceTextField.text, @"amount", nil];
            [hairfieDic setObject:price forKey:@"price"];
        }
        
        
        HairfieRepository *hairfieRepository = (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
        
        Hairfie *hairfieToPost = (Hairfie *)[hairfieRepository modelWithDictionary:hairfieDic];
        
        
        void (^loadErrorBlock)(NSError *) = ^(NSError *error){
            NSLog(@"Error : %@", error.description);
            [self removeSpinnerAndOverlay];
            [self showUploadFailedAlertView];

        };
        void (^loadSuccessBlock)(Hairfie *) = ^(Hairfie *hairfiePosted){
            
            NSLog(@"Hairfie Posté");
            [self removeSpinnerAndOverlay];
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        [hairfieToPost saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
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

-(void) uploadHairfiePicture:(UIImage *)image
{
    uploadInProgress = YES;
    PictureUploader *pictureUploader = [[PictureUploader alloc] init];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        uploadInProgress = NO;
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSString *) = ^(NSString *fileName){
        NSLog(@"Uploaded !");
        uploadedFileName = fileName;
        uploadInProgress = NO;
    };
    
    [pictureUploader uploadImage:image toContainer:@"hairfies" success:loadSuccessBlock failure:loadErrorBlock];
}

-(void)addDoneButtonToPriceField {
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    keyboardDoneButtonView.barTintColor = [UIColor redHairfie];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"OK", @"Post_Hairfie", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(doneClicked:)];
    doneButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *flex =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                       target:self
                                                       action:nil];

    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex, doneButton, flex, nil]];
    _priceTextField.inputAccessoryView = keyboardDoneButtonView;
}

- (IBAction)doneClicked:(id)sender {
    NSLog(@"Done Clicked.");
    [_priceTextField endEditing:YES];
}

-(void)showUploadFailedAlertView {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedStringFromTable(@"There was an error uploading your hairfie, Try Again !", @"Post_Hairfie", nil)  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self uploadHairfiePicture:_hairfie];
}

@end

