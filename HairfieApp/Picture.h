//
//  Picture.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property (strong, nonatomic) NSString *url;

-(id)initWithUrl:(NSString *)anUrl;

@end
