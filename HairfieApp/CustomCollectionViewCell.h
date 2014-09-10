//
//  CustomCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 08/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *hairfieView;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *nbLikes;

@property (nonatomic) UIImageView *profilePicture;


-(void)initWithUser:(User *)user;

@end
