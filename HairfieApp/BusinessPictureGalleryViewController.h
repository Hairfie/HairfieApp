//
//  BusinessPictureGalleryViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 2/16/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessPictureGalleryViewController : IDMPhotoBrowser <IDMPhotoBrowserDelegate>


-(void) restrictRotation:(BOOL) restriction;
@end
