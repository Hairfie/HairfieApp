//
//  NewHairfieCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 2/18/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "NewHairfieCollectionViewCell.h"

@implementation NewHairfieCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.hairfieBttn setTitle:NSLocalizedStringFromTable(@"Add a Hairfie", @"Salon_Detail", nil) forState:UIControlStateNormal];
}

@end
