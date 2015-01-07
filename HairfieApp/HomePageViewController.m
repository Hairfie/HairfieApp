//
//  HomePageViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/7/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController
{
    NSArray *pickerItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.font = [UIFont fontWithName:@"SourceSansPro-Light" size:17];
    pickerItems = [[NSArray alloc] initWithObjects:@"Hairfies", @"Réserver", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return 2;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return pickerItems[item];
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
