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
    
    UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(127, 10, 66, 66)];
    addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
    addPictureBttn.clipsToBounds = YES;
    addPictureBttn.layer.borderWidth = 1.0f;
    addPictureBttn.layer.borderColor = [UIColor colorWithRed:206/255.0f green:208/255.0f blue:210/255.0f alpha:1].CGColor;
    addPictureBttn.backgroundColor = [UIColor clearColor];
    [addPictureBttn addTarget:self
                 action:@selector(addPicture)
       forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 17, 50, 50)];
    addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
    addPictureLabel.textColor = [UIColor colorWithRed:148/255.0f green:154/255.0f blue:162/255.0f alpha:1];
    addPictureLabel.text = @"Add Photo";
    addPictureLabel.textAlignment = NSTextAlignmentCenter;
    addPictureLabel.numberOfLines = 2;
    
    [_mainScrollView addSubview:addPictureBttn];
    [_mainScrollView addSubview:addPictureLabel];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
