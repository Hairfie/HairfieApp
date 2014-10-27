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
#import "DateUtils.h"

@implementation BusinessReview

+(NSString *)EVENT_SAVED
{
    return @"BusinessReview.saved";
}

-(void)setAuthor:(id)aUser
{
    _author = [User fromSetterValue:aUser];
}

-(void)setBusiness:(id)aBusiness
{
    _business = [Business fromSetterValue:aBusiness];
}

-(void)setCreatedAt:(id)aDate
{
    _createdAt = [DateUtils dateFromSetterValue:aDate];
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
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[BusinessReview EVENT_SAVED]
                                                            object:self];
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


+(void)getReviewsByAuthor:(NSString *)userId
                   success:(void(^)(NSArray *reviews))aSuccessHandler
                   failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *where = [[NSMutableDictionary alloc] initWithDictionary:@{@"authorId": userId}];
    
    
    NSDictionary *parameters = @{
                                 @"filter": @{
                                         @"where":where,
                                         }
                                 };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessReviews" verb:@"GET"]
                                        forMethod:@"businessReviews.find"];
    
    LBModelRepository *repository = [[self class] repository];
    
    [repository invokeStaticMethod:@"find"
                        parameters:parameters
                           success:^(NSArray *results) {
                               NSMutableArray *reviews = [[NSMutableArray alloc] init];
                               for (NSDictionary *result in results) {
                                   [reviews addObject:[[BusinessReview alloc] initWithDictionary:result]];
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
