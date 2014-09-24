//
//  FinalStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepViewController.h"
#import "SecondStepSalonPhoneViewController.h"
#import "FinalStepAddressViewController.h"
#import "Address.h"

@interface FinalStepViewController ()

@end

@implementation FinalStepViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"CLAIM %@", _claim);
    _phoneBttn.titleLabel.text = _claim.phoneNumber;

    _addressBttn.titleLabel.text = [_claim.address displayAddress];
    _nameLabel.text = _claim.name;
    
    _validateBttn.layer.cornerRadius = 5;
    _validateBttn.layer.masksToBounds = YES;
    _addHairfiesBttn.layer.cornerRadius = 5;
    _addHairfiesBttn.layer.masksToBounds = YES;
    UIView *borderBttn =[[UIView alloc] initWithFrame:CGRectMake(105, 35, 110, 110)];
    borderBttn.backgroundColor = [UIColor whiteColor];
    borderBttn.alpha = 0.2;
    borderBttn.layer.cornerRadius = borderBttn.frame.size.height / 2;
    borderBttn.clipsToBounds = YES;
    
    UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(110, 40, 100, 100)];
    addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
    addPictureBttn.clipsToBounds = YES;
  //  addPictureBttn.layer.borderWidth = 5.0f;
  //  addPictureBttn.layer.borderColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.8].CGColor;
    addPictureBttn.backgroundColor = [UIColor redHairfie];
    [addPictureBttn addTarget:self
                       action:@selector(chooseCameraType)
             forControlEvents:UIControlEventTouchUpInside];
    [_pageControlView addSubview:borderBttn];
    [_pageControlView addSubview:addPictureBttn];
    
    
    UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 60, 50, 50)];
    addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    addPictureLabel.textColor = [UIColor whiteColor];
    addPictureLabel.text = @"Add Pictures";
    addPictureLabel.textAlignment = NSTextAlignmentCenter;
    addPictureLabel.numberOfLines = 2;
    [_pageControlView addSubview:addPictureLabel];
    


    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _phoneBttn.titleLabel.text = _claim.phoneNumber;
    
    _addressBttn.titleLabel.text = [_claim.address displayAddress];
    
    _nameLabel.text = _claim.name;
}

-(void) chooseCameraType
{

}


-(IBAction)changeTab:(id)sender {
    if(sender == _infoBttn) {
        [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
        _infoView.hidden = NO;
    } else if(sender == _hairfieBttn) {
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
        _hairfieView.hidden = NO;
    } else if(sender == _hairdresserBttn) {
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
        _hairdresserView.hidden = NO;
    } else if(sender == _priceAndSaleBttn) {
        [self setButtonSelected:_priceAndSaleBttn andBringViewUpfront:_priceAndSaleView];
        _priceAndSaleView.hidden = NO;
    }
}


-(void)setButtonSelected:(UIButton*) button andBringViewUpfront:(UIView*) view {
    
    [_containerView bringSubviewToFront:view];
    [self unSelectAll];
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:1]];
}

-(void) setNormalStateColor:(UIButton*) button
{
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.9]];
}

-(void) unSelectAll
{
    _infoView.hidden = YES;
    _hairfieView.hidden = YES;
    _hairdresserView.hidden = YES;
    _priceAndSaleView.hidden = YES;
    [self setNormalStateColor:_infoBttn];
    [self setNormalStateColor:_hairfieBttn];
    [self setNormalStateColor:_hairdresserBttn];
    [self setNormalStateColor:_priceAndSaleBttn];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)modifyPhoneNumber:(id)sender
{
    [self performSegueWithIdentifier:@"claimPhone" sender:self];
}

-(IBAction)modifyName:(id)sender
{
    [self performSegueWithIdentifier:@"claimSalon" sender:self];
}

-(IBAction)modifyAddress:(id)sender
{
    [self performSegueWithIdentifier:@"claimAddress" sender:self];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"claimSalon"])
    {
        
        SecondStepSalonPhoneViewController *salon = [segue destinationViewController];
        salon.isFinalStep = YES;
        salon.isExisting = YES;
        salon.isSalon = YES;
        salon.headerTitle = @"Salon's name";
        salon.textFieldPlaceHolder = @"Salon's name";
        salon.textFieldFromSegue = _claim.name;
        
    }
    
    if ([segue.identifier isEqualToString:@"claimPhone"])
    {
        
        SecondStepSalonPhoneViewController *phone = [segue destinationViewController];
        phone.isFinalStep = YES;
        phone.isExisting = YES;
        phone.isSalon = NO;
        phone.headerTitle = @"Phone Number";
        phone.textFieldPlaceHolder = @"Phone number";
        phone.textFieldFromSegue = _claim.phoneNumber;
        
    }
    if ([segue.identifier isEqualToString:@"claimAddress"])
    {
        FinalStepAddressViewController *claimAddress = [segue destinationViewController];
        claimAddress.address = _claim.address;
    
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
