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
{
    NSString *bodyPlaceholder;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerTitleLabel.text = NSLocalizedStringFromTable(@"Report an error", @"BusinessErrorReport", nil);

    self.headerSubmitButton.layer.cornerRadius = 5;
    [self.headerSubmitButton setTitle:NSLocalizedStringFromTable(@"Submit", @"BusinessErrorReport", nil)
                             forState:UIControlStateNormal];

    bodyPlaceholder = NSLocalizedStringFromTable(@"Error report...", @"BusinessErrorReport", nil);
    self.bodyText.text = bodyPlaceholder;
    self.bodyText.delegate = self;
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
    
    if ([body isEqualToString:bodyPlaceholder]) {
        body = nil;
    } else if ([body isEqualToString:@""]) {
        body = nil;
    }
    
    BusinessErrorReport *report = [[BusinessErrorReport alloc] initWithBusiness:self.business body:body];
    
    [report saveWithSuccess:^() { [self errorReportSubmitted]; }
                    failure:^(NSError *error) {
                        NSLog(@"Failed to submit error report: %@", error.localizedDescription);
                    }];
}

-(void)errorReportSubmitted
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.bodyText.text isEqualToString:bodyPlaceholder]) {
        self.bodyText.text = @"";
    }
}

@end
