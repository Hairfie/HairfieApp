//
//  TagsTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *tagCategory;

-(void)setTags:(NSArray*)tags;

@end
