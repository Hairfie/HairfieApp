//
//  CustomCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 08/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hairfie.h"
#import "User.h"
#import "Hairfie.h"

@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *hairfieView;

@property (nonatomic, strong) IBOutlet UIImageView *secondHairfieView;

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *nbLikes;
@property (nonatomic, strong) IBOutlet UIImageView *likes;


@property (nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic) IBOutlet UIImageView *priceView;
@property (nonatomic) IBOutlet UILabel *priceLabel;


-(void)setHairfie:(Hairfie *)hairfie;
-(void)setAsNewHairfieButton;

@end
