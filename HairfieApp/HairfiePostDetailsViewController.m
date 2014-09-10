//
//  HairfiePostDetailsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostDetailsViewController.h"
#import "PictureUploader.h"
#import "AppDelegate.h"
#import "HairfieRepository.h"
#import "Business.h"

#import <LoopBack/LoopBack.h>

@implementation HairfiePostDetailsViewController
{
    NSArray *salonTypes;
    NSString *uploadedFileName;
    BOOL uploadInProgress;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad
{
    _priceTextView.layer.cornerRadius = 5;
    _priceTextView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _priceTextView.layer.borderWidth = 0.5;
    UIColor *placeholder = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    [_emailTextField setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    _hairfieImageView.image= _hairfie;
    _hairfieDesc.alpha = 0.5;
    _dataChoice.hidden = TRUE;
    _dataChoice.layer.borderWidth = 1;
    _dataChoice.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_dataChoice setSeparatorInset:UIEdgeInsetsZero];
    _isSalon = NO;
    _isHairdresser = NO;
    salonTypes = [[NSArray alloc] initWithObjects:@"I did it", @"Hairdresser in a Salon", nil];
    _tableViewHeight.constant = [salonTypes count] * _dataChoice.rowHeight;
    [self uploadProfileImage:_hairfie];
}

-(void)viewWillAppear:(BOOL)animated
{
    LBModel *model = (LBModel *)_salonChosen;
    if (_salonChosen != nil)
        _salonLabel.text = [model objectForKeyedSubscript:@"name"];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showSalonsChoices:(id)sender
{
    if (_isSalon == YES) {
        _dataChoice.hidden = YES;
        _isSalon = NO;
    } else {
        _tableViewYPos.constant = 213;
        _salonOrHairdresser = YES;
        [_dataChoice reloadData];
        _dataChoice.hidden = NO;
        _isSalon = YES;
    }
}

-(IBAction)showHairdresserChoices:(id)sender
{
    if (_isHairdresser == YES) {
        _dataChoice.hidden = YES;
        _isHairdresser = NO;
    } else {
        _tableViewYPos.constant = 268;
        _salonOrHairdresser = NO;
        [_dataChoice reloadData];
        _dataChoice.hidden = NO;
        _isHairdresser = YES;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _hairfieDesc && [_hairfieDesc.text isEqualToString:@"Add a description..."])
    {
        _hairfieDesc.text = @"";
        _hairfieDesc.alpha = 1;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == _hairfieDesc && [_hairfieDesc.text isEqualToString:@""])
    {
        _hairfieDesc.text = @"Add a description ...";
        _hairfieDesc.alpha = 0.5;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (_salonOrHairdresser == YES)
    {
        if (indexPath.row != 0)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [salonTypes objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
        cell.textLabel.textColor = [UIColor colorWithRed:191/255.0f green:194/255.0f blue:199/255.0f alpha:1];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Haidresser %ld", indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        [self performSegueWithIdentifier:@"choseSalonType" sender:self];
        [self showSalonsChoices:self];
    }
    else
    {
        _salonLabel.text = @"I did it";
        [self showSalonsChoices:self];
    }
}


-(IBAction)postHairfie:(id)sender
{
    while (uploadInProgress) {
        NSLog(@"Loop Loop !");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
    Business *business = (Business*)_salonChosen;
    
    
    
    NSDictionary *hairfieDic = [[NSDictionary alloc] initWithObjectsAndKeys:uploadedFileName, @"picture",_hairfieDesc.text, @"description", nil];

    if ([business objectForKeyedSubscript:@"name"])
        [hairfieDic setValue:[business objectForKeyedSubscript:@"id"] forKey:@"businessId"];
    
    HairfieRepository *hairfieRepository = (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
    
    Hairfie *hairfieToPost = (Hairfie *)[hairfieRepository modelWithDictionary:hairfieDic];
    
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(Hairfie *) = ^(Hairfie *hairfiePosted){
        
        NSLog(@"Hairfie Posté");
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [hairfieToPost saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}

-(void) uploadProfileImage:(UIImage *)image
{
    uploadInProgress = YES;
    PictureUploader *pictureUploader = [[PictureUploader alloc] init];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        uploadInProgress = NO;
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSString *) = ^(NSString *fileName){
        NSLog(@"Uploaded !");
        uploadedFileName = fileName;
        uploadInProgress = NO;
    };
    
    [pictureUploader uploadImage:image toContainer:@"hairfies" success:loadSuccessBlock failure:loadErrorBlock];
}

@end

