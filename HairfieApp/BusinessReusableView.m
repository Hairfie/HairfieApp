//
//  BusinessReusableView.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessReusableView.h"

@implementation BusinessReusableView
{
    BOOL isSetup;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setupView {
    
    if (!isSetup) {
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.detailsBttn.frame.size.height, self.detailsBttn.frame.size.width, 4)];
        bottomBorder.backgroundColor = [UIColor salonDetailTab];
        bottomBorder.tag = 1;
        [self.detailsBttn addSubview:bottomBorder];
        [self decorateButton:self.detailsBttn withImage:@"infos" active:YES];
        isSetup = YES;
    }
}


-(IBAction)changeTab:(id)sender
{
    [self setButtonSelected:sender];
}

-(void)decorateButton:(UIButton *)aButton withImage:(NSString *)anImage active:(BOOL)isActive
{
    NSString *imageName;
    if (isActive) {
        imageName = [NSString stringWithFormat:@"tab-business-%@-active", anImage];
    } else {
        imageName = [NSString stringWithFormat:@"tab-business-%@", anImage];
    }
    
    [aButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)setButtonSelected:(UIButton*)aButton
{

    [self decorateButton:self.detailsBttn withImage:@"infos" active:NO];
    [self decorateButton:self.hairfiesBttn withImage:@"hairfies" active:NO];
    [self decorateButton:self.hairdressersBttn withImage:@"hairdressers" active:NO];
    [self decorateButton:self.servicesBttn withImage:@"prices" active:NO];
    
    if (aButton == self.detailsBttn) {
        [self decorateButton:self.detailsBttn withImage:@"infos" active:YES];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"businessDetails" object:self];
    } else if (aButton == self.hairfiesBttn) {
        [self decorateButton:self.hairfiesBttn withImage:@"hairfies" active:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"businessHairfies" object:self];
    } else if (aButton == self.hairdressersBttn) {
        [self decorateButton:self.hairdressersBttn withImage:@"hairdressers" active:YES];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"businessHairdressers" object:self];

    } else if (aButton == self.servicesBttn) {
        [self decorateButton:self.servicesBttn withImage:@"prices" active:YES];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"businessServices" object:self];
    }
    
    for (UIButton *btn in @[self.detailsBttn, self.hairfiesBttn, self.hairdressersBttn, self.servicesBttn]) {
        for (UIView *subView in btn.subviews) {
            if (subView.tag == 1) [subView removeFromSuperview];
        }
    }
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 4)];
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    [aButton addSubview:bottomBorder];
}


@end