//
//  LoadingCollectionViewCell.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 16/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *endOfScroll;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

-(void) showEndOfScroll;

@end
