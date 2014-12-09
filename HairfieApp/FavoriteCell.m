//
//  FavoriteCell.m
//  HairfieApp
//
//  Created by Leo Martin on 12/9/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FavoriteCell.h"
#import "Business.h"

@implementation FavoriteCell
{
    Business *hairdressersBusiness;
    Hairdresser *currentHairdresser;
    UIImageView *hairdresserPicture;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell:(Hairdresser*)hairdresser
{
    [self getBusiness:hairdresser];
    [self.hairdresserName setTitle:[hairdresser displayFullName] forState:UIControlStateNormal];
    [self.hairdresserBusiness setTitle:hairdresser.business.name forState:UIControlStateNormal];
    self.hairdresserBusiness.layer.cornerRadius = 5;
    self.hairdresserBusiness.layer.masksToBounds = YES;
    CGSize textSize = [[self.hairdresserBusiness.titleLabel text] sizeWithAttributes:@{NSFontAttributeName:[self.hairdresserBusiness.titleLabel font]}];
    self.businessWidth.constant = textSize.width + 20;
    
    [self.hairdresserHairfies setText:[NSString stringWithFormat:@"%@ hairfies", hairdresser.numHairfies]];
    }

-(void)getBusiness:(Hairdresser*)hairdresser{
    
   
    [Business getById:hairdresser.business.id withSuccess:^(Business *business) {
        hairdressersBusiness = business;
        hairdresserPicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [hairdresserPicture sd_setImageWithURL:[business.owner pictureUrlwithWidth:@100 andHeight:@100]
                                   placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
        
        hairdresserPicture.clipsToBounds = YES;
        hairdresserPicture.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
        hairdresserPicture.layer.borderWidth = 1;
        hairdresserPicture.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:hairdresserPicture];

    }
              failure:^(NSError *error) {
                  NSLog(@"Failed to retrieve complete business: %@", error.localizedDescription);
              }];

}

@end
