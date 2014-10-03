//
//  BusinessReview.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessReview.h"
#import "BusinessReviewRepository.h"
#import "AppDelegate.h"

@implementation BusinessReview

- (void)setAuthor:(NSDictionary *)authorDic
{
    if([authorDic isKindOfClass:[NSNull class]]) return;
    
    _author = [[User alloc] initWithDictionary:authorDic];
}

- (void) setBusiness:(NSDictionary *)aDictionary
{
    if ([aDictionary isEqual:[NSNull null]]) {
        _business = nil;
    } else if ([aDictionary isKindOfClass:[Business class]]) {
        _business = aDictionary;
    } else {
        _business = [[[self class] alloc] initWithDictionary:aDictionary];
    }
}

-(void)setCreatedAt:(NSDate *)aDate
{
    if ([aDate isKindOfClass:[NSString class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:API_DATE_FORMAT];
        _createdAt = [dateFormatter dateFromString:aDate];
    } else {
        _createdAt = aDate;
    }
}

-(id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];

    self = (BusinessReview *)[[BusinessReview repository] modelWithDictionary:data];
    
    return self;
}

-(NSNumber *)ratingBetween:(NSNumber *)theMin // TODO: scale from the min
                       and:(NSNumber *)theMax
{
    if ([self.rating isEqual:[NSNull null]]) {
        return nil;
    }
    
    return [[NSNumber alloc] initWithFloat:[self.rating floatValue] * [theMax floatValue] / 100];
}

-(void)setRating:(NSNumber *)theRating
         between:(NSNumber *)theMin // TODO: scale from the min
             and:(NSNumber *)theMax
{
    if ([theRating isEqual:[NSNull null]]) {
        self.rating = nil;
    }

    self.rating = [[NSNumber alloc] initWithFloat:[theRating floatValue] * (100 / [theMax floatValue])];
}

-(void)save
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reviewSaved" object:self];
    };
    
    NSDictionary *parameters = @{
        @"businessId": self.business.id,
        @"rating": self.rating,
        @"comment": self.comment
    };
    
    [[[self class] repository] invokeStaticMethod:@""
                                       parameters:parameters
                                          success:loadSuccessBlock
                                          failure:loadErrorBlock];
}

+(void)listLatestByBusiness:(NSString *)aBusinessId
                      limit:(NSNumber *)aLimit
                       skip:(NSNumber *)aNumber
                    success:(void (^)(NSArray *))aSuccessHandler
                    failure:(void (^)(NSError *))aFailureHandler
{
        NSDictionary *parameters = @{
                                     @"filter": @{
                                             @"where": @{@"businessId": aBusinessId},
                                             @"limit": aLimit,
                                             @"skip": aNumber,
                                             @"order": @"createdAt DESC"
                                             }
                                     };
        
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessReviews" verb:@"GET"]
                                            forMethod:@"businessReviews.find"];
        
        LBModelRepository *repository = [self repository];
        
        [repository invokeStaticMethod:@"find"
                            parameters:parameters
                               success:^(NSArray *results) {
                                   NSMutableArray *reviews = [[NSMutableArray alloc] init];
                                   for (NSDictionary *result in results) {
                                       [reviews addObject:[repository modelWithDictionary:result]];
                                   }
                                   aSuccessHandler([[NSArray alloc] initWithArray:reviews]);
                               }
                               failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessReviewRepository class]];
}



@end
