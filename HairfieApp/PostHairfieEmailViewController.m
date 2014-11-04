//
//  PostHairfieEmailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "PostHairfieEmailViewController.h"
#import "HairfiePostDetailsViewController.h"

@interface PostHairfieEmailViewController ()

@end

@implementation PostHairfieEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerTitle.text = NSLocalizedStringFromTable(@"email hairfie", @"Post_Hairfie", nil);
    _validateBttn.layer.cornerRadius = 5;
    _validateBttn.layer.masksToBounds = YES;
    _emailField.layer.cornerRadius = 5;
    _emailField.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _emailField.layer.borderWidth = 1;
    _emailField.placeholder = NSLocalizedStringFromTable(@"email hairfie placeholder", @"Post_Hairfie", nil);
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 10, 10)];
    [_emailField setLeftViewMode:UITextFieldViewModeAlways];
    [_emailField setLeftView:spacerView];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.emailField becomeFirstResponder];
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
        [self addEmailToHairfiePost:self];
        [nextResponder resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addEmailToHairfiePost:(id)sender
{
     HairfiePostDetailsViewController *hairfieDetails = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    
    
    if ([self isValidEmail:_emailField.text]) {
        
        [self.hairfiePost setCustomerEmail: _emailField.text];
        [hairfieDetails setHairfiePost:self.hairfiePost];
        [self goBack:self];
    }
    else
        [self showMessage:NSLocalizedStringFromTable(@"email not valid", @"Post_Hairfie", nil) withTitle:NSLocalizedStringFromTable(@"error", @"Post_Hairfie", nil)];
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

- (void) showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
