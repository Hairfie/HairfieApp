//
//  PictureUploader.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 08/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "PictureUploader.h"
#import "AppDelegate.h"

@implementation PictureUploader {
    AppDelegate *delegate;
}

-(void) uploadImage:(UIImage *) image
               toContainer:(NSString *) containerName
                   success:(uploadSuccessBlock) success
                    failure:(SLFailureBlock) failure {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imgName = @"pictureToUpload.jpg";
    NSString *imgPath = NSTemporaryDirectory();
    
    NSString *fullPath = [imgPath stringByAppendingPathComponent:imgName];
    
    if ([fileManager fileExistsAtPath:fullPath]) {
        [fileManager removeItemAtPath:fullPath error:nil];
    }
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:fullPath atomically:YES];
    
    LBFileRepository *repository = (LBFileRepository*)[[AppDelegate lbAdaptater] repositoryWithClass:[LBFileRepository class]];
    LBFile __block *file =
        [repository createFileWithName:imgName localPath:imgPath container:containerName];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error in upload : %@", error.description);
        failure(error);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"File upload results: %@", results);
        NSDictionary *uploadedFile = [[[results objectForKey:@"result"] objectForKey:@"files"] objectForKey:@"uploadfiles"];
        
        success([[Picture alloc] initWithDictionary:uploadedFile]);
    };
    
    [file invokeMethod:@"upload"
            parameters:[file toDictionary]
               success:loadSuccessBlock
               failure:loadErrorBlock];
}

@end
