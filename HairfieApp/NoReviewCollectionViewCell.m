//
//  NoReviewCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 12/29/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "NoReviewCollectionViewCell.h"

@implementation NoReviewCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    noReviewLbl.text = NSLocalizedStringFromTable(@"No Review", @"UserProfile", nil);
}

@end
