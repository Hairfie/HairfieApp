//
//  BusinessPictureGalleryViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 2/16/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "BusinessPictureGalleryViewController.h"
#import "AppDelegate.h"
@interface BusinessPictureGalleryViewController ()

@end

@implementation BusinessPictureGalleryViewController
{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"KOOL STORY BREAU");
    [self restrictRotation:NO];
    // Do any additional setup after loading the view.

}


-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
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
