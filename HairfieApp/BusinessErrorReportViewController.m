//
//  BusinessErrorReportViewController.m
//  HairfieApp
//
//  Created by Antoine Hérault on 29/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessErrorReportViewController.h"
#import "BusinessErrorReport.h"

@interface BusinessErrorReportViewController ()

@end

@implementation BusinessErrorReportViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerTitleLabel.text = NSLocalizedStringFromTable(@"Report an error", @"BusinessErrorReport", nil);

    self.headerSubmitButton.layer.cornerRadius = 5;
    [self.headerSubmitButton setTitle:NSLocalizedStringFromTable(@"Submit", @"BusinessErrorReport", nil)
                             forState:UIControlStateNormal];

    self.bodyText.placeholder = NSLocalizedStringFromTable(@"Error report...", @"BusinessErrorReport", nil);
    self.bodyText.layer.cornerRadius = 5;
    self.bodyText.layer.borderColor = [UIColor lightGrey].CGColor;
    self.bodyText.layer.borderWidth = 1;
    [self.bodyText becomeFirstResponder];
}



-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitErrorReport:(id)sender
{
    NSString *body = self.bodyText.text;

    if ([body isEqualToString:@""]) {
        body = nil;
    }

    BusinessErrorReport *report = [[BusinessErrorReport alloc] initWithBusiness:self.business body:body];
    
    [report saveWithSuccess:^() { [self errorReportSubmitted]; }
                    failure:^(NSError *error) {
                        NSLog(@"Failed to submit error report: %@", error.localizedDescription);
                    }];
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [self submitErrorReport:self];
        return NO;
    }else{
        return YES;
    }
}
-(void)errorReportSubmitted
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
