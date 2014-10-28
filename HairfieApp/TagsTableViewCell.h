//
//  TagsTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tag, TagsTableViewCell;

@protocol TagsTableViewCellDelegate
- (void)tagWasSelected:(Tag*)tag inCell:(TagsTableViewCell*)cell isSelected:(BOOL)selected;
@end

@interface TagsTableViewCell : UITableViewCell


@property (nonatomic) IBOutlet UILabel *tagCategory;

@property (weak, nonatomic) id<TagsTableViewCellDelegate> delegate;

-(void)setTags:(NSArray*)tags;

@end
