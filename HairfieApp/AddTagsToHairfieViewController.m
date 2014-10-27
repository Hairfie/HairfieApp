//
//  AddTagsToHairfieViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AddTagsToHairfieViewController.h"
#import "UIView+Borders.h"

@interface AddTagsToHairfieViewController ()

@end

@implementation AddTagsToHairfieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.topView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
    // Do any additional setup after loading the view.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
