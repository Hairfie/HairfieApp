//
//  SignUpViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpTableViewCell.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statusBarButton.layer.cornerRadius = 5;
    _statusBarButton.layer.masksToBounds = YES;
    _infoView.layer.cornerRadius = 5;
    _infoView.layer.masksToBounds = YES;
    _infoView.layer.borderWidth = 1;
    _infoView.layer.borderColor = [UIColor colorWithRed:206/255.0f green:208/255.0f blue:210/255.0f alpha:1].CGColor;
    _isChecked = NO;
    
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(127, 10, 66, 66)];
    addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
    addPictureBttn.clipsToBounds = YES;
    addPictureBttn.layer.borderWidth = 1.0f;
    addPictureBttn.layer.borderColor = [UIColor colorWithRed:206/255.0f green:208/255.0f blue:210/255.0f alpha:1].CGColor;
    addPictureBttn.backgroundColor = [UIColor clearColor];
    [addPictureBttn addTarget:self
                 action:@selector(takePicture)
       forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 17, 50, 50)];
    addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
    addPictureLabel.textColor = [UIColor colorWithRed:148/255.0f green:154/255.0f blue:162/255.0f alpha:1];
    addPictureLabel.text = @"Add Photo";
    addPictureLabel.textAlignment = NSTextAlignmentCenter;
    addPictureLabel.numberOfLines = 2;
    
    [_mainScrollView addSubview:addPictureBttn];
    [_mainScrollView addSubview:addPictureLabel];
    [self.view addGestureRecognizer:_dismiss];

    // Do any additional setup after loading the view.
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
    if(_isChecked == YES)
    {
        [_checkBoxButton setImage:[UIImage imageNamed:@"checkbox-false.png"] forState:UIControlStateNormal];
        _isChecked = NO;
    } else {
        [_checkBoxButton setImage:[UIImage imageNamed:@"checkbox-true.png"] forState:UIControlStateNormal];
        _isChecked = YES;
    }
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
        [self.view removeGestureRecognizer:_dismiss];
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
   
    UIAlertView *chooseCameraType = [[UIAlertView alloc] initWithTitle:@"Choose camera type" message:@"Take picture or pick one from the saved photos" delegate:self cancelButtonTitle:@"Photo Albums" otherButtonTitles:@"Camera", nil];
    chooseCameraType.delegate = self;
    [chooseCameraType show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            _camera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    } if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            _camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            _camera.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _camera.showsCameraControls = NO;
            _camera.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            
            [self presentViewController:_camera animated:YES completion:nil];
       
        }
    }
     */
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
