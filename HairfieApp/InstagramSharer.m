//
//  InstagramSharer.m
//  HairfieApp
//
//  Created by Antoine Hérault on 07/11/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "InstagramSharer.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation InstagramSharer

+(void)interactionControllerForImageWithURL:(NSURL *)anURL
                                    success:(void (^)(UIDocumentInteractionController *))onSuccess
                                    failure:(void (^)(NSError *))onFailure
{
    [[self class] downloadImageWithURL:anURL
                               success:^(UIImage *image) {
                                   NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                                   NSString *imagePath = [[self class] filePath];
                                   NSFileManager *fileManager = [NSFileManager defaultManager];
                                   [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                                   NSURL *fileURL = [NSURL fileURLWithPath:imagePath];
                                   UIDocumentInteractionController *dic = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
                                   dic.UTI = @"com.instagram.exclusivegram";
                                   
                                   onSuccess(dic);
                               }
                               failure:onFailure];
}

+(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"hairfie-share-instagram.igo"];
}

+(void)downloadImageWithURL:(NSURL *)anURL
                    success:(void (^)(UIImage *))onSuccess
                    failure:(void (^)(NSError *))onFailure
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:anURL
                                                          options:nil
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            if (nil != image) {
                                                                onSuccess(image);
                                                            } else {
                                                                onFailure(error);
                                                            }
                                                        }];
}

@end
