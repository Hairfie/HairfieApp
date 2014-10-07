//
//  ClaimAddPricesSalesViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimAddPricesSalesViewController.h"
#import "FinalStepViewController.h"
#import "Service.h"

@interface ClaimAddPricesSalesViewController ()

@end

@implementation ClaimAddPricesSalesViewController
{
    NSMutableArray *services;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    services = [[NSMutableArray alloc] init];
    _priceDescriptionView.layer.cornerRadius = 5;
    _priceDescriptionView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _priceDescriptionView.layer.borderWidth = 1;
    
    _priceValueView.layer.cornerRadius = 5;
    _priceValueView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _priceValueView.layer.borderWidth = 1;
    
    _doneBttn.layer.cornerRadius = 5;
    _doneBttn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_serviceClaimed != nil)
        services = _serviceClaimed;
    if (_serviceFromSegue != nil)
    {
        _priceValue.text = [NSString stringWithFormat:@"%@",_serviceFromSegue.price.amount ];
        _priceDescription.text = _serviceFromSegue.label;
    }
    
}

-(void)addService
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * priceAmount = [formatter numberFromString:_priceValue.text];
    Money *priceToAdd = [[Money alloc] initWithAmount:priceAmount currency:@"EUR"];
  
    Service *serviceToAdd = [[Service alloc] initWithLabel:_priceDescription.text price:priceToAdd];
  
    [services addObject:serviceToAdd];
    
}

-(IBAction)validatePricesSales:(id)sender
{
    // TO DO enregistrer les prix/promos ajoutés
    [self addService];
    
    
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

    if (finalStep.businessToManage != nil)
        finalStep.businessToManage.services = services;
//    else
//        finalStep.claim.services = services;
//    
   NSLog(@"service %@", finalStep.businessToManage.services);
    
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
        [self validatePricesSales:self];
        [textField resignFirstResponder];
    }
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
