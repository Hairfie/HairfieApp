//
//  TutoContentViewController.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TutoContentViewController.h"

@interface TutoContentViewController ()

@end

@implementation TutoContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = self.titleText;
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
