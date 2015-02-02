//
//  BusinessHairdressersCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessMember.h"

@interface BusinessHairdressersCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UITextField *businessMemberName;
@property (nonatomic) IBOutlet UIImageView *disclosureIndicator;
@property (nonatomic) IBOutlet UIImageView *businessMemberPicture;

-(void)setBusinessMember:(BusinessMember *)businessMember;

@end
