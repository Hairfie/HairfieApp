//
//  LikeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 29/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "LikeViewController.h"
#import "AppDelegate.h"

@interface LikeViewController ()

@end

@implementation LikeViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    // Do any additional setup after loading the view.
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
