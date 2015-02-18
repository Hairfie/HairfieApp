//
//  ClaimAddServicesViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimAddServicesViewController.h"
#import "FinalStepViewController.h"
#import "UITextField+Style.h"
#import "Service.h"

@interface ClaimAddServicesViewController ()

@end

@implementation ClaimAddServicesViewController
{
    NSMutableArray *services;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    services = [[NSMutableArray alloc] init];

    [self.serviceValue textFieldWithPhoneKeyboard:(self.view.frame.size.width / 2 - 50)];
    self.doneBttn.layer.cornerRadius = 5;
    self.doneBttn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.serviceClaimed != nil)
        services = _serviceClaimed;
    if (self.serviceFromSegue != nil)
    {
        self.serviceValue.text = [NSString stringWithFormat:@"%@",self.serviceFromSegue.price.amount];
        self.serviceDescription.text = self.serviceFromSegue.label;
    }
    
}

-(void)addService
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * serviceAmount = [formatter numberFromString:self.serviceValue.text];
    Money *price = [[Money alloc] initWithAmount:serviceAmount currency:@"EUR"];
  
    Service *serviceToAdd = [[Service alloc] initWithLabel:_serviceDescription.text price:price];
    
  
    if (_serviceFromSegue != nil)
        [services replaceObjectAtIndex:_serviceIndexFromSegue withObject:serviceToAdd];
    else
        [services addObject:serviceToAdd];
    
}

-(IBAction)validateservicesSales:(id)sender
{
    // TO DO enregistrer les prix/promos ajoutés
    [self addService];
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

    if (finalStep.businessToManage != nil)
        finalStep.businessToManage.services = services;
    
    [self goBack:self];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self validateservicesSales:self];
        [textField resignFirstResponder];
    }
    return YES;
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
