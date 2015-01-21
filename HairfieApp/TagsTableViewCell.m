//
//  TagsTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagsTableViewCell.h"
#import "AddTagsToHairfieViewController.h"
#import <Underscore.m/Underscore.h>
#import "Tag.h"

@implementation TagsTableViewCell
{
    NSInteger indentValue;
    BOOL isSelected;
    NSMutableArray *tagsSelected;
    NSMutableDictionary *tagsDic;
    NSArray *tagsList;
}
- (void)awakeFromNib {
    // Initialization code
    tagsSelected = [[NSMutableArray alloc] init];
    tagsDic = [[NSMutableDictionary alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTags:(NSArray*)tags withSelectedTags:(NSArray*)selectedTags
{
    tagsList = [NSArray arrayWithArray:tags];
    NSInteger posX = 10;
    indentValue = 0;
    NSInteger screenWidth = self.bounds.size.width;
    for (int i = 1; i < [tags count] + 1; i++) {
     
        Tag *tag = [tags objectAtIndex:i - 1];
        UIButton *button = [[UIButton alloc] init];
        CGRect frame;
        [button setTitle:tag.name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i != 1)
            posX += indentValue + 15;
         button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:17];
        [self getLabelWidth:button.titleLabel];
        
        BOOL isTagSelected = _.any(selectedTags, ^BOOL (Tag *hairfieTag){
         return [tag.id isEqualToString:hairfieTag.id];
        });
        
        [button setSelected:isTagSelected];
        
        frame.origin.x = posX;
        if (i == 1)
            frame.origin.y = 40;
        
        if (posX + indentValue >= screenWidth - 20)
        {
            frame.origin.y += 30;
            posX = 10;
            frame.origin.x = posX;
        }
        
        frame.size.width = indentValue + 10;
        frame.size.height = 27;
       
        if (button.selected == NO) {
           
            [button setTitleColor:[UIColor colorWithRed:148/255.f green:153/255.0f blue:161/255.0f alpha:1] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:240/255.f green:241/255.0f blue:241/255.0f alpha:1]];
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor salonDetailTab]];
        }
        
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setFrame:frame];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.tag = i - 1;
        
        [self addSubview:button];
    }
}

-(void)getLabelWidth:(UILabel*)aLabel
{
    float widthIs =
    [aLabel.text
     boundingRectWithSize:aLabel.frame.size
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{ NSFontAttributeName:aLabel.font }
     context:nil]
    .size.width;
    
    indentValue = (int)ceilf(widthIs) + 10;
}

-(IBAction)buttonClicked:(UIButton*)sender
{
    Tag *tag = [tagsList objectAtIndex:sender.tag];
    
    if (sender.selected == YES) {
        [sender setTitleColor:[UIColor colorWithRed:148/255.f green:153/255.0f blue:161/255.0f alpha:1] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:240/255.f green:241/255.0f blue:241/255.0f alpha:1]];
        sender.selected = NO;
        [self.delegate tagWasSelected:tag isSelected:NO];
    } else {
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor salonDetailTab]];
        sender.selected = YES;
        [self.delegate tagWasSelected:tag isSelected:YES];
    }
    
}


@end
