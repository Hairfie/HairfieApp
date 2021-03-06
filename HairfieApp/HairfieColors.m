//
//  HairfieColors.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieColors.h"

@implementation UIColor (HairfieColors)

+(UIColor *)lightBlueHairfie {
    // Hexa :
    return [UIColor colorWithRed:92/255.0 green:172/255.0 blue:225/255.0 alpha:1];
}

+(UIColor *)blackHairfie {
    // Hexa : #283139
    return [UIColor colorWithRed:40/255.0 green:49/255.0 blue:57/255.0 alpha:1];
}

+(UIColor *)darkBlueHairfie {
    // Hexa : #324357
    return [UIColor colorWithRed:49/255.0 green:67/255.0 blue:88/255.0 alpha:1];
}

+(UIColor *)blueHairfie {
    // Hexa : #297ba6
    return [UIColor colorWithRed:35/255.0 green:122/255.0 blue:168/255.0 alpha:1];
}

+(UIColor *)redHairfie {
    // Hexa : #e85546
    return [UIColor colorWithRed:234/255.0 green:84/255.0 blue:64/255.0 alpha:1];
}

+(UIColor *)greyHairfie {
    // Hexa : #465567
    return [UIColor colorWithRed:69/255.0 green:85/255.0 blue:104/255.0 alpha:1];
}

// Opening hours
+(UIColor *)greenHairfie {
    // Hexa :
    return [UIColor colorWithRed:50/255.0 green:178/255.0 blue:81/255.0 alpha:1];
}

+(UIColor *)whiteHairfie {
    // Hexa :
    return [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1];
}

+(UIColor *)lightGreyHairfie {
    // Hexa :
    return [UIColor colorWithRed:214/255.0f green:217/255.0f blue:221/255.0f alpha:1];
}


// Nouvelle charte

+(UIColor *)pinkHairfie {
    // Hexa :
    return [UIColor colorWithRed:254/255.0f green:91/255.0f blue:95/255.0f alpha:1];
}

+(UIColor *)pinkBtnHairfie {
    return [UIColor colorWithRed:254/255.0f green:124/255.0f blue:127/255.0f alpha:1];
}


+(UIColor *)lightGrey {
    return [UIColor colorWithRed:240/255.0f green:240/255.0f blue:241/255.0f alpha:1];
}

+(UIColor *)darkGrey {
    return [UIColor colorWithRed:131/255.0f green:138/255.0f blue:151/255.0f alpha:1];
}

+(UIColor *)titleGrey {
    return [UIColor colorWithRed:105/255.0f green:113/255.0f blue:123/255.0f alpha:1];
}

+(UIColor *)salonDetailTab {
    return [UIColor colorWithRed:255/255.0f green:117/255.0f blue:113/255.0f alpha:1];
}

+(UIColor *)lightBlackTab {
    return [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3];
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end