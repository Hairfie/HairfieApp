//
//  PostSalonTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 10/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostSalonTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *salonPicture;
@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *address;
@property (nonatomic) IBOutlet UILabel *city;

@end
