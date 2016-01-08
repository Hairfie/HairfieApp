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
//    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[self.business.thumbnail urlWithWidth:@100 height:@100]
//                                                        options:0
//                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
//                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                                                          if (image && finished) {
//                                                              self.salonPicture.image = image;
//                                                          }
//                                                      }];
//    self.salonPicture.image
    [self.salonPicture sd_setImageWithURL:[self.business.thumbnail urlWithWidth:@100 height:@100]
                           placeholderImage:[UIImage imageNamed:@"placeholder-100.png"]];
    
    self.name.text = self.business.name;
    self.numHairfiesLabel.text = self.business.displayNumHairfies;
    
    self.ratingView.rating = [[self.business ratingBetween:@0 and:@5] floatValue];
    if ([self.business.numReviews isEqualToNumber:@0]) {
        
        NSString *rateInt = NSLocalizedStringFromTable(@"rate this hairdresser", @"BusinessTableCell", nil);

        self.statusLabel.text = [NSString stringWithFormat:@"- %@", rateInt];
        
    } else if ([self.business.numReviews isEqualToNumber:@1]) {
       
         NSString *rateInt = NSLocalizedStringFromTable(@"review", @"BusinessTableCell", nil);
       

        self.statusLabel.text = [NSString stringWithFormat:@"- 1 %@", rateInt];
    
    
    } else {
        
        NSString *rateInt = NSLocalizedStringFromTable(@"reviews", @"BusinessTableCell", nil);
        
        self.statusLabel.text = [NSString stringWithFormat:@"- %@ %@", self.business.numReviews, rateInt];
    }
    
    if ([self.business.kind isEqualToString:KIND_ATHOME]) {
        self.locationPinImage.hidden = YES;
        self.location.hidden = FALSE;
        self.location.text = [NSLocalizedStringFromTable(@"At home", @"BusinessTableCell", nil) uppercaseString];
    } else {
        if (nil == self.locationForDistance) {
            self.location.hidden = YES;
            self.locationPinImage.hidden = YES;
        } else {
            self.location.text = [NSString stringWithFormat:@"%.1f km", [[self.business distanceTo:self.locationForDistance] floatValue] / 1000];
            self.location.hidden = NO;
            self.locationPinImage.hidden = NO;
        }
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
