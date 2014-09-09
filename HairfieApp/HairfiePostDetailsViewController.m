//
//  HairfiePostDetailsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostDetailsViewController.h"

@implementation HairfiePostDetailsViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad
{
    _priceTextView.layer.cornerRadius = 5;
    _priceTextView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _priceTextView.layer.borderWidth = 0.5;
    UIColor *placeholder = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    [_emailTextField setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    _hairfieImageView.image= _hairfie;
    
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end

