//
//  FirstStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FirstStepViewController.h"
#import "SecondStepViewController.h"

@interface FirstStepViewController ()

@end

@implementation FirstStepViewController

 

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _claim = [[BusinessClaim alloc] init];
    
    _salonBttn.layer.cornerRadius =5;
    _salonBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _salonBttn.layer.borderWidth = 1;
    
    _homeBttn.layer.cornerRadius =5;
    _homeBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _homeBttn.layer.borderWidth = 1;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pickKindSalon:(id)sender
{
    if ([sender tag] == 0)
        _claim.kind = KIND_INSALON;
    if ([sender tag] == 1)
        _claim.kind = KIND_ATHOME;
    
    NSLog(@"claim %@", _claim);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"REZ :%@", results);
        _claim.id = [results objectForKey:@"id"];
        [self performSegueWithIdentifier:@"claimKindSalon" sender:self];
    };
    
    [_claim claimWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimKindSalon"])
    {
        SecondStepViewController *secondStep = [segue destinationViewController];
        secondStep.claim = [[BusinessClaim alloc] init];
        secondStep.claim = _claim;
    }
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
