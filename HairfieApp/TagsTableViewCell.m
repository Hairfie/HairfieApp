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
{
    NSInteger indentValue;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTags:(NSArray*)tags
{
    NSInteger posX = 10;
    indentValue = 0;
    NSInteger screenWidth = self.bounds.size.width;
    for (int i = 1; i < [tags count] + 1; i++) {
     
        Tag *tag = [tags objectAtIndex:i - 1];
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:tag.name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i != 1)
            posX += indentValue + 15;
         button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:13];
        [self getLabelWidth:button.titleLabel];
        
      
       
        
        CGRect frame;
        frame.origin.x = posX;
        frame.origin.y = 40;
        if (posX + indentValue >= screenWidth)
        {
            frame.origin.y += 30;
            frame.origin.x = 10;
        }
        frame.size.width = indentValue + 10;
        frame.size.height = 27;
       
        button.titleLabel.textColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor salonDetailTab];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setFrame:frame];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.tag = i;
       
        
       // NSLog(@"TAG NAME %@", tag.name);
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
    
    indentValue = (int)ceilf(widthIs);
}

-(IBAction)buttonClicked:(UIButton*)sender
{
  
    
    NSLog(@"BUTTON CLICKED %ld", sender.tag);
}
@end
