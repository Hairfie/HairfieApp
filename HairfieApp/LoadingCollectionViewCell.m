//
//  LoadingCollectionViewCell.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 16/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "LoadingCollectionViewCell.h"

@implementation LoadingCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _endOfScroll.text = NSLocalizedStringFromTable(@"End of Hairfies", @"Feed", nil);
    _endOfScroll.hidden = YES;
}

-(void) showEndOfScroll {
    
    _endOfScroll.hidden = NO;
    _spinner.hidden = YES;

}
@end
