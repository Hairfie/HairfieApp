//
//  TagsTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagsTableViewCell.h"
#import "Tag.h"

@implementation TagsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTags:(NSArray*)tags
{
    int plusX = 40;

    for (int i = 1; i < [tags count] + 1; i++) {
     
        Tag *tag = [tags objectAtIndex:i - 1];
        
        // pos initiale
        
        int posX = 10 * i;
        if (posX > 10)
            posX = (10 + plusX) * i;
        /////
        UILabel *label = [[UILabel alloc] init];
        
        if (posX != 10)
        {
            [label setFrame:CGRectMake(posX, 30, 50, 30)];
        }
        else
            [label setFrame:CGRectMake(posX, 30, 50, 30)];
        
        label.text = tag.name;
       
    
       // NSLog(@"TAG NAME %@", tag.name);
        [self addSubview:label];
    }
}

@end
