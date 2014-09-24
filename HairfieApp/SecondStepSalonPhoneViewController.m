//
//  SecondStepSalonPhoneViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SecondStepSalonPhoneViewController.h"
#import "SecondStepViewController.h"
#import "FinalStepViewController.h"

@interface SecondStepSalonPhoneViewController ()

@end

@implementation SecondStepSalonPhoneViewController

@synthesize headerTitle, headerLabel,textFieldPlaceHolder, textField, textFieldFromSegue;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerLabel.text = headerTitle;
    textField.placeholder = textFieldPlaceHolder;
   
    UIView *fieldPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    if (_isExisting == YES)
    {
        textField.text = textFieldFromSegue;
    }
    if (_isSalon == NO)
    {
        textField.keyboardType = UIKeyboardTypePhonePad;
        [self addDoneButtonToPriceField];
    }
    textField.layer.cornerRadius =5;
    textField.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    textField.layer.borderWidth = 1;
    textField.leftView = fieldPadding;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyDone;
    _doneBttn.layer.cornerRadius = 5;
    [textField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    [_textField resignFirstResponder];
    
    [self doneClicked:self];
    return YES;
}




-(void) addDoneButtonToPriceField {


    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barTintColor = [UIColor redHairfie];
    //keyboardDoneButtonView.backgroundColor = [UIColor redHairfie];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Validate phone", @"Claim", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(doneClicked:)];
    doneButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 90;
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedSpace,doneButton, nil]];
    
    textField.inputAccessoryView = keyboardDoneButtonView;
}


- (IBAction)doneClicked:(id)sender
{
    
    [textField resignFirstResponder];
    
    if (_isFinalStep == NO){
        SecondStepViewController *claim = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        if (_isSalon == NO)
        {
            claim.isPhoneSet = YES;
            claim.phoneTextField.text = textField.text;
        }
        else
        {
            claim.isSalonSet = YES;
            claim.salonTextField.text = textField.text;
        }
    }
    else
    {
        FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        if (_isSalon == NO)
        {
            finalStep.claim.phoneNumber = textField.text;
        }
        else
        {
            NSLog(@"COU");
            finalStep.claim.name = textField.text;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

-(BOOL) checkPhone
{
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [textField.text length]);
    NSArray *matches = [detector matchesInString:textField.text options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}



-(IBAction)goBack:(id)sender
{
    [self doneClicked:self];
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
