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

@interface SignUpViewController ()

@end

@implementation SignUpViewController
{
    UIAlertView *chooseCameraType;
    UIImagePickerController *imagePicker;
    NSArray *title;
    AppDelegate *delegate;
    NSDictionary *userData;
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
    title = [NSArray arrayWithObjects:@"Femme", @"Homme", nil];
    UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(127, 10, 66, 66)];
    addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
    addPictureBttn.clipsToBounds = YES;
    addPictureBttn.layer.borderWidth = 1.0f;
    addPictureBttn.layer.borderColor = [UIColor colorWithRed:206/255.0f green:208/255.0f blue:210/255.0f alpha:1].CGColor;
    addPictureBttn.backgroundColor = [UIColor clearColor];
    [addPictureBttn addTarget:self
                 action:@selector(chooseCameraType)
       forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 17, 50, 50)];
    addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
    addPictureLabel.textColor = [UIColor colorWithRed:148/255.0f green:154/255.0f blue:162/255.0f alpha:1];
    addPictureLabel.text = @"Add Photo";
    addPictureLabel.textAlignment = NSTextAlignmentCenter;
    addPictureLabel.numberOfLines = 2;
     _userTitleLabel.text = @"Femme";
    _titleView.hidden = YES;

    [_mainScrollView addSubview:addPictureBttn];
    [_mainScrollView addSubview:addPictureLabel];

    // Do any additional setup after loading the view.
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)createAccount:(id)sender
{
    [self hideKeyboard];
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        
        NSLog(@"results %@", results);
        userData = results;
        delegate.currentUser.firstName = [results objectForKey:@"firstName"];
        delegate.currentUser.lastName = [results objectForKey:@"firstName"];
        delegate.currentUser.picture = [results objectForKey:@"picture"];
        
        [self performSegueWithIdentifier:@"createAccount" sender:self];
    };
    
    if ([self isValidEmail: _emailField.text])
    {
        
        NSNumber *newsletter;
        if (_isNewsletterChecked == TRUE)
            newsletter = @true;
        else
            newsletter = @false;
        NSString *gender;
        if([_userTitleLabel.text isEqualToString:@"Homme"])
                gender = @"male";
        else
            gender = @"female";
        
        NSString *repoName = @"users";
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users" verb:@"POST"] forMethod:@"users"];
        
        LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        
        [loginData invokeStaticMethod:@"" parameters:@{@"firstName":_firstNameField.text, @"lastName":_lastNameField.text, @"email": _emailField.text, @"password" : _passwordField.text, @"newsletter":newsletter, @"gender":gender} success:loadSuccessBlock failure:loadErrorBlock];
        
    }
    else
    {
        UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"The email/password in incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [badLogin show];
    }
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
    [self.navigationController popViewControllerAnimated:YES];
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
        NSLog(@"Fin");
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

-(void)chooseCameraType
{
   
    chooseCameraType = [[UIAlertView alloc] initWithTitle:@"Choose camera type" message:@"Take picture or pick one from the saved photos" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Library",nil];
    chooseCameraType.delegate = self;
    [chooseCameraType show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    imagePicker = [[UIImagePickerController alloc]init];
     [imagePicker setDelegate:self];
    if (buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            //_camera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
           
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    } if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePicker.showsCameraControls = NO;
            
            imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            [self initOverlayView];
            
                       [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}


-(void) initOverlayView
{
    
    UIView *overlayView = [[UIView alloc] init];
    
    overlayView.frame =  imagePicker.cameraOverlayView.frame;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    navigationView.backgroundColor = [UIColor blackHairfie];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(10, 32, 20, 20)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = @"Post Hairfie";
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    [overlayView addSubview:navigationView];
    
    
    UIImage *takePictureImg = [UIImage imageNamed:@"take-picture-button.png"];
    
    UIButton *takePictureButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(snapPicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 401, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(268, 75, 32, 32)];
    
    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:takePictureButton];
    
    imagePicker.cameraOverlayView = overlayView;
}


- (void)switchCamera
{
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
    {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

-(void)snapPicture
{
    [imagePicker takePicture];
}

-(void) cancelTakePicture
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self setProfilePicture:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)setProfilePicture:(UIImage*) image
{
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(127, 10, 66, 66)];
    
    profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePicture.image = image;
    
    [_mainScrollView addSubview:profilePicture];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    

    [self setProfilePicture:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
