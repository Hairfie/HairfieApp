//
//  LoginViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noAccountButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _noAccountButton.layer.borderWidth = 0.5;
    _noAccountButton.backgroundColor = [UIColor clearColor];
    _noAccountButton.layer.cornerRadius = 5;
    _noAccountButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
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
        [self doLogin];
    }
    return YES;
}

-(void)doLogin
{
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    };
    
     NSString *repoName = @"users";
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/login" verb:@"POST"] forMethod:@"users.login"];
    
    LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
    [loginData invokeStaticMethod:@"login" parameters:@{@"email": _emailField.text, @"password" : _passwordField.text} success:loadSuccessBlock failure:loadErrorBlock];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
