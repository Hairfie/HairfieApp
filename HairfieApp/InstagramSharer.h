//
//  InstagramSharer.h
//  HairfieApp
//
//  Created by Antoine Hérault on 07/11/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramSharer : NSObject

+(void)interactionControllerForImageWithURL:(NSURL *)anURL
                                    success:(void(^)(UIDocumentInteractionController *))onSuccess
                                    failure:(void(^)(NSError *error))onFailure;

@end
