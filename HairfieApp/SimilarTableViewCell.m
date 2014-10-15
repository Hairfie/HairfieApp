//
//  SimilarTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SimilarTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

@implementation SimilarTableViewCell

-(void)awakeFromNib
{
    _salonPicture.layer.cornerRadius = 5;
    _salonPicture.layer.masksToBounds = YES;
    
    _bookButton.layer.cornerRadius = 5;
    _bookButton.layer.masksToBounds = YES;
    
   // _salonPicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 0;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    _salonPicture.image = [UIImage imageNamed:@"placeholder-image.jpg"];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(businessChanged:)
                                                 name:[Business EVENT_CHANGED]
                                               object:nil];
}

-(void)businessChanged:(NSNotification *)notification
{
    Business *changedBusiness = (Business *)notification.object;
    
    if (changedBusiness == self.business) {
        [self refresh];
    }
}

-(void)setBusiness:(Business *)business
{
    _business = business;
    [self refresh];
}

-(void)setLocationForDistance:(GeoPoint *)locationForDistance
{
    _locationForDistance = locationForDistance;
    [self refresh];
}

-(void)refresh
{
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.business.thumbUrl]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                          if (image && finished) {
                                                              self.salonPicture.image = image;
                                                          }
                                                      }];
    
    self.name.text = self.business.name;
    self.numHairfiesLabel.text = self.business.displayNumHairfies;
    
    self.ratingView.rating = [[self.business ratingBetween:@0 and:@5] floatValue];
    if ([self.business.numReviews isEqualToNumber:@0]) {
        self.statusLabel.text = NSLocalizedStringFromTable(@"- rate this hairdresser", @"BusinessTableCell", nil);
    } else if ([self.business.numReviews isEqualToNumber:@1]) {
        self.statusLabel.text = NSLocalizedStringFromTable(@"- 1 review", @"BusinessTableCell", nil);
    } else {
        self.statusLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"- %@ reviews", @"BusinessTableCell", nil), self.business.numReviews];
    }
    
    if (nil == self.locationForDistance) {
        self.location.hidden = YES;
        self.locationPinImage.hidden = YES;
    } else {
        self.location.text = [NSString stringWithFormat:@"%.1f km", [[self.business distanceTo:self.locationForDistance] floatValue] / 1000];
        self.location.hidden = NO;
        self.locationPinImage.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

@end
