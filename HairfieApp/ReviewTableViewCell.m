//
//  ReviewTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ReviewTableViewCell.h"

@interface ReviewTableViewCell ()

@end

@implementation ReviewTableViewCell

@synthesize ratingView = _ratingView, name = _name, content = _content, statusLabel = _statusLabel, postDate = _postDate;

- (void)awakeFromNib {
    
    
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 9, 41, 41)];
    
    // mettre viariable photo salon ici
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    [self.viewForBaselineLayout addSubview:profilePicture];
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 3;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    _statusLabel.text = [NSString stringWithFormat:@"3"];
    _postDate.text = [NSString stringWithFormat:@"-  %@", @"Juillet 2014"];
    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
