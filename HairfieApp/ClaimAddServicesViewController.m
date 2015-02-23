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
#import "Money.h"

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
    [self.serviceDuration textFieldWithPhoneKeyboard:(self.view.frame.size.width / 2 - 50)];

    self.serviceDescription.tag = 0;
    self.serviceDuration.tag = 1;
    self.serviceValue.tag = 2;
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
        self.serviceDuration.text = [NSString stringWithFormat:@"%@",self.serviceFromSegue.durationMinutes];
    }
    
}

-(void)addService
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * serviceAmount = [formatter numberFromString:self.serviceValue.text];
    
    NSNumber *duration = [formatter numberFromString:self.serviceDuration.text];
    
    Money *price = [[Money alloc] initWithAmount:serviceAmount currency:@"EUR"];
    
  
    Service *serviceToAdd = [[Service alloc] initWithLabel:_serviceDescription.text price:price duration:duration businessId:self.businessId serviceId:nil];
    
    if (self.serviceFromSegue != nil)
        serviceToAdd.id = self.serviceFromSegue.id;
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *result){
        NSLog(@"Results : %@", result);
        
        Money *savedPrice = [[Money alloc] initWithDictionary:[result objectForKey:@"price"]];
        
        Service *savedService = [[Service alloc] initWithLabel:[result objectForKey:@"label"] price:savedPrice duration:[result objectForKey:@"durationMinutes"] businessId:self.businessId serviceId:[result objectForKey:@"id"]];
      
        NSArray *filteredServices = _.filter(services, ^BOOL(Service *serviceToTest){
            return ![serviceToTest.id isEqualToString:savedService.id];
        });
        
        NSMutableArray *servicesToSend = [NSMutableArray arrayWithArray:filteredServices];
        [servicesToSend addObject:savedService];
        
        FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        if (finalStep.businessToManage != nil) {
         
            finalStep.businessToManage.services = servicesToSend;
       
        }
        

        [self goBack:self];

    };
    
    
    [serviceToAdd saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    
}

-(IBAction)validateservicesSales:(id)sender
{
    // TO DO enregistrer les prix/promos ajoutés
    [self addService];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Try to find next responder
    if (textField == self.serviceDescription) {
        // Found next responder, so set it.
        [self.serviceDuration becomeFirstResponder];
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
