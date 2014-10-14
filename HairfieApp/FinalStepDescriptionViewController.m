//
//  FinalStepDescriptionViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepDescriptionViewController.h"
#import "FinalStepViewController.h"

@interface FinalStepDescriptionViewController ()

@end

@implementation FinalStepDescriptionViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _descriptionView.layer.cornerRadius =5;
    _descriptionView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _descriptionView.layer.borderWidth = 1;
    _doneBttn.layer.cornerRadius = 5;
 
    [_descriptionView becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    if (_desc != nil)
        _descriptionView.text = _desc;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validateDescription:(id)sender
{
    // TO DO enregistrer la description modifiée
     FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    if (finalStep.businessToManage != nil)
        finalStep.businessToManage.desc = _descriptionView.text;
    else
        finalStep.claim.desc = _descriptionView.text;
    [self goBack:self];
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
