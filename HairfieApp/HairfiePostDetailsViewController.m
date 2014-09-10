//
//  HairfiePostDetailsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostDetailsViewController.h"

@implementation HairfiePostDetailsViewController
{
    NSArray *salonTypes;
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
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"choseSalonType"])
    {
        NSLog(@"Cool");
    }
}

@end

