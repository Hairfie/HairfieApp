//
//  SignUpViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UserAuthenticator.h"
#import "Picture.h"
#import "MRProgress.h"
#import "ImageSetPicker.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController {
    UIAlertView *chooseCameraType;
    UIImagePickerController *imagePicker;
    NSArray *title;
    AppDelegate *delegate;
    NSDictionary *userData;
    Picture *uploadedPicture;
    BOOL uploadInProgress;
    UserAuthenticator *userAuthenticator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _statusBarButton.layer.cornerRadius = 5;
    _statusBarButton.layer.masksToBounds = YES;
    _infoView.layer.cornerRadius = 5;
    _infoView.layer.masksToBounds = YES;
    _infoView.layer.borderWidth = 1;
    _infoView.layer.borderColor = [UIColor colorWithRed:206/255.0f green:208/255.0f blue:210/255.0f alpha:1].CGColor;
    _isNewsletterChecked = NO;
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    title = [NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Woman", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Man", @"Login_Sign_Up", nil), nil];
    
    self.addPictureButton.layer.cornerRadius = self.addPictureButton.frame.size.height / 2;
    self.addPictureButton.clipsToBounds = YES;
    self.addPictureButton.layer.borderWidth = 1.0f;
    self.addPictureButton.layer.borderColor = [UIColor colorWithRed:206/255.0f green:208/255.0f blue:210/255.0f alpha:1].CGColor;
    self.addPictureButton.backgroundColor = [UIColor clearColor];
    [self.addPictureButton addTarget:self
                 action:@selector(takePicture)
       forControlEvents:UIControlEventTouchUpInside];
    
    self.addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
    self.addPictureLabel.textColor = [UIColor colorWithRed:148/255.0f green:154/255.0f blue:162/255.0f alpha:1];
    self.addPictureLabel.text = NSLocalizedStringFromTable(@"Add Photo", @"Login_Sign_Up", nil);
    self.addPictureLabel.textAlignment = NSTextAlignmentCenter;
    self.addPictureLabel.numberOfLines = 3;
    self.addPictureLabel.minimumScaleFactor = 0.2;

     _userTitleLabel.text = NSLocalizedStringFromTable(@"Woman", @"Login_Sign_Up", nil);
    _titleView.hidden = YES;
    
    userAuthenticator = [[UserAuthenticator alloc] init];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [ARAnalytics pageView:@"AR - Sign up"];
}

-(NSInteger)imageSetPickerMinimumImageCount:(ImageSetPicker *)imageSetPicker
{
    return 1;
}

-(NSInteger)imageSetPickerMaximumImageCount:(ImageSetPicker *)imageSetPicker
{
    return 1;
}

-(void)imageSetPickerDidCancel:(ImageSetPicker *)imageSetPicker
{
    [ImageSetPicker remove:imageSetPicker];
}

-(void)imageSetPicker:(ImageSetPicker *)imageSetPicker didReturnWithImages:(NSArray *)images
{
    [ImageSetPicker remove:imageSetPicker];
    [self defineProfilePicture:images[0]];
}

-(void) setUserTitle
{
    NSLog(@"control");
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return title.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return title[row];
} 


-(IBAction)showTitlePicker:(id)sender
{
    [self hideKeyboard];
    _titleView.hidden = NO;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"%@", [title objectAtIndex:row]);
    _userTitleLabel.text = [title objectAtIndex:row];
    [_firstNameField becomeFirstResponder];
    _titleView.hidden = YES;
    
}

-(IBAction)createAccount:(id)sender
{
    [self hideKeyboard];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedStringFromTable(@"Sign up in progress", @"Login_Sign_Up", nil) mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        NSLog(@"results %@", [results objectForKey:@"accessToken"]);
        NSDictionary *token = [results objectForKey:@"accessToken"];
        [delegate.credentialStore setAuthTokenAndUserId:[token objectForKey:@"id"] forUser:[results objectForKey:@"id"]];
        [AppDelegate lbAdaptater].accessToken = [token objectForKey:@"id"];
        
        [userAuthenticator getCurrentUser];
        
        [self performSegueWithIdentifier:@"@Main" sender:self];
    };
    
    if ([self isValidEmail: _emailField.text])
    {
        NSNumber *newsletter;
        if (_isNewsletterChecked == TRUE)
            newsletter = @true;
        else
            newsletter = @false;
        NSString *gender;
        if([_userTitleLabel.text isEqualToString:NSLocalizedStringFromTable(@"Man", @"Login_Sign_Up", nil)]) {
            gender = GENDER_MALE;
        } else {
            gender = GENDER_FEMALE;
        }
        
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        while (uploadInProgress) {
            NSLog(@"Loop Loop !");
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        if(uploadedPicture) {
            [User signUpUserWithFirstName:self.firstNameField.text lastName:self.lastNameField.text email:self.emailField.text password:self.passwordField.text gender:gender language:language picture:uploadedPicture.toApiValue withNewsletter:newsletter success:loadSuccessBlock failure:loadErrorBlock];
        } else {
            [User signUpUserWithFirstName:self.firstNameField.text lastName:self.lastNameField.text email:self.emailField.text password:self.passwordField.text gender:gender language:language picture:nil withNewsletter:newsletter success:loadSuccessBlock failure:loadErrorBlock];
        }
    }
    else
    {
        UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Sign up Failed", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"The email/password in not valid", @"Login_Sign_Up", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [badLogin show];
    }
}

-(void) uploadProfileImage:(UIImage *)image
{
    uploadInProgress = YES;
    Picture *imagePost = [[Picture alloc] initWithImage:image andContainer:@"user-profile-pictures"];

    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        uploadInProgress = NO;
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(void) = ^(void){
        uploadedPicture = imagePost;
        uploadInProgress = NO;
    };
    
    [imagePost uploadWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}


-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
        
-(void)addPicture {
    
    NSLog(@"add Picture");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)checkBox:(id)sender
{
    if(_isNewsletterChecked == YES)
    {
        [_checkBoxButton setImage:[UIImage imageNamed:@"checkbox-false.png"] forState:UIControlStateNormal];
        _isNewsletterChecked = NO;
    } else {
        [_checkBoxButton setImage:[UIImage imageNamed:@"checkbox-true.png"] forState:UIControlStateNormal];
        _isNewsletterChecked = YES;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
     [_mainScrollView addGestureRecognizer:_dismiss];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [_mainScrollView removeGestureRecognizer:_dismiss];
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) hideKeyboard
{
    [_titleField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

-(void)takePicture
{
    [ImageSetPicker setup:self];
}


-(void)defineProfilePicture:(UIImage*)image
{
    [self uploadProfileImage:image];
    
    self.profilePicture.hidden = NO;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 2;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderWidth = 1.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePicture.image = image;
}

@end