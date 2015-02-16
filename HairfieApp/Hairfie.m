//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"
#import "UserRepository.h"
#import "BusinessRepository.h"
#import "AppDelegate.h"
#import "SetterUtils.h"
#import "DateUtils.h"
#import "URLUtils.h"
#import "Tag.h"
#import "NSDate+TimeAgo.h"

@implementation Hairfie

@synthesize description = _description;

+(NSString *)EVENT_SAVED
{
    return @"Hairfie.saved";
}

-(id)initWithDictionary:(NSDictionary *)data
{
    self = (Hairfie*)[[Hairfie repository] modelWithDictionary:data];
    if (self) {
        
        if ([[data objectForKey:@"displayBusiness"] isEqualToNumber:@1]) {
            self.displayBusiness = YES;
        } else {
            self.displayBusiness = NO;
        }

        self.selfMade = [[data objectForKey:@"selfMade"] isEqualToNumber:@1];
    }
    return self;
}

-(void)setDescription:(NSString *)aDescription
{
    if ([aDescription isEqual:[NSNull null]] || aDescription.length == 0)
    {
        _description  = @"";
    }
    else
        _description = aDescription;
}


-(void)setAuthor:(id)aUser
{
    _author = [User fromSetterValue:aUser];
}

-(void)setBusiness:(id)aBusiness
{
    _business = [Business fromSetterValue:aBusiness];
}

-(void)setBusinessMember:(id)aBusinessMember
{
    _businessMember = [BusinessMember fromSetterValue:aBusinessMember];
}

-(void)setPicture:(id)aPicture
{
    _picture = [Picture fromSetterValue:aPicture];
}



-(void)setPrice:(id)aPrice
{
    _price = [Money fromSetterValue:aPrice];
}

-(void)setLandingPageUrl:(id)landingPageUrl
{
    _landingPageUrl = [URLUtils URLFromSetterValue:landingPageUrl];
}

-(void)setCreatedAt:(id)aDate
{
    _createdAt = [DateUtils dateFromSetterValue:aDate];
}

-(void)setUpdatedAt:(id)aDate
{
    _updatedAt = [DateUtils dateFromSetterValue:aDate];
}

-(void)setPictures:(id)somePictures
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (![somePictures isEqual:[NSNull null]]) {
        for (id aPicture in somePictures) {
            [temp addObject:[Picture fromSetterValue:aPicture]];
        }
    }
    _pictures = [[NSArray alloc] initWithArray:temp];
}


-(void)setTags:(id)someTags
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (![someTags isEqual:[NSNull null]]) {
        for (id aTag in someTags) {
            [temp addObject:[Tag fromSetterValue:aTag]];
        }
    }
    _tags = [[NSArray alloc] initWithArray:temp];
}

-(Picture *)mainPicture
{
    if (self.pictures.count < 1) {
        return nil;
    }
    
    return [self.pictures objectAtIndex:self.pictures.count-1];
}

-(BOOL)hasSecondaryPicture
{
    return nil != [self secondaryPicture];
}

-(Picture *)secondaryPicture
{
    if (self.pictures.count < 2) {
        return nil;
    }
    
    return [self.pictures objectAtIndex:0];
}

-(NSURL *)pictureUrlWithWidth:(NSNumber *)width andHeight:(NSNumber *)height
{
    return [self.picture urlWithWidth:width height:height];
}

-(NSURL *)pictureUrl
{
    return [self pictureUrlWithWidth:nil andHeight:nil];
}

-(NSString *)displayPrice
{
    if([self.price isEqual:[NSNull null]]) return @"";
    
    return self.price.formatted;
}

-(NSString *)displayNumLikes {
    return [NSString stringWithFormat:@"%@", _numLikes];
}

-(NSString *)displayNumComments {
    return [NSString stringWithFormat:@"%@", _numComments];
}

-(NSString *)displayShortDate {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DISPLAY_DATE_FORMAT];
    NSString *stringFromDate = [dateFormat stringFromDate:_createdAt];

    return stringFromDate;
}

-(NSString*)displayTimeAgo {
    return [_createdAt timeAgo];
}

-(NSAttributedString *)displayDescAndTags {
    NSDictionary *descAttributes = @{
                               NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Light" size:15],
                               NSForegroundColorAttributeName : [[UIColor blackHairfie] colorWithAlphaComponent:0.8]
                               };
    
    NSDictionary *tagsAttributes = @{
                                     NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Light" size:15],
                                     NSForegroundColorAttributeName : [UIColor salonDetailTab]
                                    // NSBackgroundColorAttributeName : [UIColor colorWithRed:240/255.f green:241/255.0f blue:241/255.0f alpha:1]
                                     };
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:self.description attributes:descAttributes];
    
    NSString *tagsString = [_.arrayMap(self.tags, ^(Tag *tag) {
        return [NSString stringWithFormat:@"#%@", tag.name];
    }) componentsJoinedByString:@" "];
    
    NSAttributedString *tags = [[NSAttributedString alloc] initWithString:tagsString attributes:tagsAttributes];

    [output appendAttributedString:tags];
    
    return (NSAttributedString *) output;
}

+(void)getHairfiesByAuthor:(NSString *)userId
                     until:(NSDate *)until
                     limit:(NSNumber *)limit
                      skip:(NSNumber *)skip
                   success:(void(^)(NSArray *hairfies))aSuccessHandler
                   failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *where = [[NSMutableDictionary alloc] initWithDictionary:@{@"authorId": userId}];
    
    if (nil != until) {
        [where setObject:@{@"lte": until} forKey:@"createdAt"];
    }
    
    NSDictionary *parameters = @{
                                 @"filter": @{
                                         @"where":where,
                                         @"limit": limit,
                                         @"skip": skip,
                                         @"order": @"createdAt DESC"
                                         }
                                 };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies" verb:@"GET"]
                                        forMethod:@"hairfies.find"];
    
    LBModelRepository *repository = [[self class] repository];
    
    [repository invokeStaticMethod:@"find"
                        parameters:parameters
                           success:^(NSArray *results) {
                               NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                               for (NSDictionary *result in results) {
                                   [hairfies addObject:[[Hairfie alloc] initWithDictionary:result]];
                               }
                               aSuccessHandler([[NSArray alloc] initWithArray:hairfies]);
                           }
                           failure:aFailureHandler];
}

+(void)listLatestByBusinessMember:(NSString*)businessMemberId
                            limit:(NSNumber *)limit
                             skip:(NSNumber *)skip
                          success:(void (^)(NSArray *))aSuccessHandler
                          failure:(void (^)(NSError *))aFailureHandler
{
    NSMutableDictionary *where = [[NSMutableDictionary alloc] initWithDictionary:@{@"businessMemberId": businessMemberId}];
    NSDictionary *parameters = @{
                                 @"filter": @{
                                         @"where":where,
                                         @"limit": limit,
                                         @"skip": skip,
                                         @"order": @"createdAt DESC"
                                         }
                                 };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies" verb:@"GET"]
                                        forMethod:@"hairfies.find"];
    
    LBModelRepository *repository = [self repository];
    
    [repository invokeStaticMethod:@"find"
                        parameters:parameters
                           success:^(NSArray *results) {
                               NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                               for (NSDictionary *result in results) {
                                   [hairfies addObject:[[[self class] alloc] initWithDictionary:result]];
                            }
                               aSuccessHandler([[NSArray alloc] initWithArray:hairfies]);
                           }
                           failure:aFailureHandler];
}



+ (void) listLatest:(NSNumber *)limit
               skip:(NSNumber *)skip
            success:(void (^)(NSArray *))aSuccessHandler
            failure:(void (^)(NSError *))aFailureHandler {
    
        NSDictionary *parameters = @{
             @"filter": @{
                     @"limit": limit,
                     @"skip": skip,
                     @"order": @"createdAt DESC"
             }
        };
        
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies" verb:@"GET"]
                                            forMethod:@"hairfies.find"];
        
        LBModelRepository *repository = [self repository];
        
        [repository invokeStaticMethod:@"find"
                            parameters:parameters
                               success:^(NSArray *results) {
                                   NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                                   for (NSDictionary *result in results) {
                                       [hairfies addObject:[[[self class] alloc] initWithDictionary:result]];
                                   }
                                   aSuccessHandler([[NSArray alloc] initWithArray:hairfies]);
                               }
                               failure:aFailureHandler];
}



+(void)listLatestPerPage:(NSNumber *)page
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler {
    NSNumber *limit = @(HAIRFIES_PAGE_SIZE);
    NSNumber *offset = @([page integerValue] * [limit integerValue]);
    
    [self listLatest:limit skip:offset success:aSuccessHandler failure:aFailureHandler];
    
}



+(void)listLatestByBusiness:(NSString *)businessId
                      until:(NSDate *)until
                      limit:(NSNumber *)limit
                       skip:(NSNumber *)skip
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler
{

    NSMutableDictionary *where = [[NSMutableDictionary alloc] initWithDictionary:@{@"businessId": businessId}];
    
    if (nil != until) {
        [where setObject:@{@"lte": until} forKey:@"createdAt"];
    }
    
    NSDictionary *parameters = @{
        @"filter": @{
            @"where":where,
            @"limit": limit,
            @"skip": skip,
            @"order": @"createdAt DESC"
        }
    };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies" verb:@"GET"]
                                        forMethod:@"hairfies.find"];
    
    LBModelRepository *repository = [self repository];
    
    [repository invokeStaticMethod:@"find"
                        parameters:parameters
                           success:^(NSArray *results) {
                               NSLog(@"SUCCESS");
                               NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                                for (NSDictionary *result in results) {
                                    [hairfies addObject:[repository modelWithDictionary:result]];
                                }
                               aSuccessHandler([[NSArray alloc] initWithArray:hairfies]);
                            }
                            failure:aFailureHandler];
}

+(void)deleteHairfie:(NSString *)hairfieId
             success:(void (^)())aSuccessHandler
             failure:(void (^)(NSError *error))aFailureHandler
{
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies/:id" verb:@"DELETE"]
                                        forMethod:@"hairfies.delete"];
    
    LBModelRepository *repository = [self repository];
    
    [repository invokeStaticMethod:@"delete"
                        parameters:@{@"id":hairfieId}
                           success:aSuccessHandler
                           failure:aFailureHandler];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
