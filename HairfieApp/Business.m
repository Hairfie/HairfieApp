//
//  Business.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Business.h"
#import "BusinessRepository.h"
#import "Address.h"
#import "GeoPoint.h"
#import "AppDelegate.h"
#import "Service.h"
#import "Picture.h"
#import "Hairdresser.h"
#import "BusinessReview.h"
#import "SetterUtils.h"

@implementation Business

+(NSString *)EVENT_CHANGED
{
    return @"Business.changed";
}

-(void)setOwner:(id)aUser
{
    _owner = [User fromSetterValue:aUser];
}

-(void)setTimetable:(id)aTimetable
{
    _timetable = [Timetable fromSetterValue:aTimetable];
}

-(void)setFacebookPage:(id)aFacebookPage
{
    _facebookPage = [FacebookPage fromSetterValue:aFacebookPage];
}

-(void)setThumbnail:(id)aPicture
{
    _thumbnail = [Picture fromSetterValue:aPicture];
}

-(void)setServices:(NSMutableArray *)services
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (![services isEqual:[NSNull null]]) {
        for (id service in services) {
            [temp addObject:[Service fromSetterValue:service]];
        }
    }
    _services = temp;
}

-(void)setActiveHairdressers:(NSArray *)hairdressers
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (![hairdressers isEqual:[NSNull null]]) {
        for (id hairdresser in hairdressers) {
            [temp addObject:[Hairdresser fromSetterValue:hairdresser]];
        }
    }
    _activeHairdressers = temp;
}

-(void)setPictures:(id)pictures
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (![pictures isEqual:[NSNull null]]) {
        for (id picture in pictures) {
            [temp addObject:[Picture fromSetterValue:picture]];
        }
    }
    _pictures = temp;
}

- (void)setAddress:(id)anAddress
{
    _address = [Address fromSetterValue:anAddress];
}

- (void)setGps:(id)aGeoPoint
{
    _gps = [GeoPoint fromSetterValue:aGeoPoint];
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setupEventListeners];
    }

    return self;
}

-(id)initWithDictionary:(NSDictionary *)data
{
    self = (Business*)[[Business repository] modelWithDictionary:data];
    
    // seems there is a parser issue with boolean values...
    if ([[data objectForKey:@"crossSell"] isEqualToNumber:@1]) {
        self.crossSell = YES;
    } else {
        self.crossSell = NO;
    }
    
    [self setupEventListeners];
    
    return self;
}

-(void)setupEventListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reviewSaved:)
                                                 name:[BusinessReview EVENT_SAVED]
                                               object:nil];
}

-(void)clearEventListeners
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [self clearEventListeners];
}

-(void)reviewSaved:(NSNotification *)notification
{
    BusinessReview *review = (BusinessReview *)notification.object;
    
    if ([self.id isEqualToString:review.business.id]) {
        NSLog(@"review saved");
        [self refreshWithSuccess:^() { NSLog(@"Business<%@> reloaded", self.id); }
                         failure:^(NSError *error) {
                             NSLog(@"Failed to reload business<%@>: %@", self.id, error.localizedDescription);
                         }];
    }
}

-(void)refreshWithSuccess:(void(^)())aSuccessHandler
                  failure:(void(^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:id" verb:@"GET"]
                                        forMethod:@"businesses.get"];

    [[[self class] repository] invokeStaticMethod:@"get"
                                       parameters:@{@"id": self.id}
                                          success:^(NSDictionary *result) {
                                              self.id = [result objectForKey:@"id"];
                                              self.owner = [result objectForKey:@"owner"];
                                              self.name = [result objectForKey:@"name"];
                                              self.gps = [result objectForKey:@"gps"];
                                              self.phoneNumber = [result objectForKey:@"phoneNumber"];
                                              self.timetable = [result objectForKey:@"timetable"];
                                              self.address = [result objectForKey:@"address"];
                                              self.pictures = [result objectForKey:@"pictures"];
                                              self.thumbnail = [result objectForKey:@"thumbnail"];
                                              self.services = [result objectForKey:@"services"];
                                              self.numHairfies = [result objectForKey:@"numHairfies"];
                                              self.numReviews = [result objectForKey:@"numReviews"];
                                              self.rating = [result objectForKey:@"rating"];
                                              self.activeHairdressers = [result objectForKey:@"activeHairdressers"];

                                              [[NSNotificationCenter defaultCenter] postNotificationName:[Business EVENT_CHANGED]
                                                                                                  object:self];

                                              aSuccessHandler();
                                          }
                                          failure:aFailureHandler];
}

-(NSString *)displayNameAndAddress
{
    return [NSString stringWithFormat:@"%@ - %@", self.address.displayCityAndZipCode, self.name];
}

-(NSString *)displayNumHairfies
{
    if ([self.numHairfies integerValue] > 1) {
        return [NSString stringWithFormat:@"%@ hairfies", self.numHairfies];
    } else {
        return [NSString stringWithFormat:@"%@ hairfie", self.numHairfies];
    }
}


-(NSString *)displayBusinessNameForQuery
{
    return [self.name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

-(NSNumber *)ratingBetween:(NSNumber *)theMin // TODO: scale from the min
                       and:(NSNumber *)theMax
{
    if ([self.rating isEqual:[NSNull null]]) {
        return nil;
    }

    return [[NSNumber alloc] initWithFloat:[self.rating floatValue] * [theMax floatValue] / 100];
}

-(NSNumber *)distanceTo:(GeoPoint *)aGeoPoint
{
    return [self.gps distanceTo:aGeoPoint];
}

-(BOOL)isFacebookPageShareEnabled
{
    return nil != self.facebookPage;
}

+(void)listNearby:(GeoPoint *)aGeoPoint
            query:(NSString *)aQuery
            limit:(NSNumber *)aLimit
          success:(void(^)(NSArray *business))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler
{
    if (nil == aQuery) {
        aQuery = @"";
    }
    

    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/nearby" verb:@"GET"] forMethod:@"businesses.nearby"];
    LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:@"businesses"];
    if(!aGeoPoint.lng || !aGeoPoint.lat){
        aFailureHandler(nil);
        return;
    }

    [businessData invokeStaticMethod:@"nearby"
                          parameters:@{@"here": [aGeoPoint toApiValue], @"limit" : aLimit, @"query" : aQuery}
                             success:^(NSArray *results) {
                                 NSMutableArray *businesses = [[NSMutableArray alloc] init];
                                 for (NSDictionary *result in results) {
                                     [businesses addObject:[[Business alloc] initWithDictionary:result]];
                                 }

                                 aSuccessHandler([[NSArray alloc] initWithArray: businesses]);
                             } failure:^(NSError *error) {
                                 aFailureHandler(error);
                             }];
}


-(void)updateWithSuccess:(void(^)(NSArray *results))aSuccessHandler
                 failure:(void(^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:id" verb:@"PUT"] forMethod:@"businesses.update"];
    
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
       [parameters setObject:self.id forKey:@"id"];
    
    if (self.name != nil)
        [parameters setObject:self.name forKey:@"name"];
  
    if (self.gps != nil)
        [parameters setObject:[self.gps toDictionary] forKey:@"gps"];
 
    if (self.phoneNumber != nil)
        [parameters setObject:self.phoneNumber forKey:@"phoneNumber"];

   if (self.timetable != nil)
        [parameters setObject:[self.timetable toDictionary] forKey:@"timetable"];

    if (self.address != nil)
        [parameters setObject:[self.address toDictionary]  forKey:@"address"];
    
     NSMutableArray *hairdresserToSend = [[NSMutableArray alloc] init];
    
    if (self.activeHairdressers != nil)
    {
          //NSMutableArray *hairdresserToSend = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.activeHairdressers count]; i++)
        {
            Hairdresser *hairdresser = [self.activeHairdressers objectAtIndex:i];
            [hairdresserToSend addObject:[hairdresser toDictionary]];
            
        }
        
        [parameters setObject:hairdresserToSend forKey:@"hairdressers"];
    }
    
    if (self.pictures != (id)[NSNull null])
    {
        NSMutableArray *pictureToSend = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.pictures count]; i++)
        {
            Picture *pic = [self.pictures objectAtIndex:i];
            [pictureToSend addObject:[pic toApiValue]];
        }
        [parameters setObject:pictureToSend forKey:@"pictures"];
    }

    if (self.services != nil)
    {
        NSMutableArray *servicesToSend = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.services count]; i++)
        {
            Service *service = [self.services objectAtIndex:i];
            [servicesToSend addObject:[service toDictionary]];
            
        }
        [parameters setObject:servicesToSend forKey:@"services"];
    }

    [[Business repository] invokeStaticMethod:@"update" parameters:parameters success:aSuccessHandler failure:aFailureHandler];
}

-(void)claimWithSuccess:(void (^)(NSArray *))aSuccessHandler failure:(void (^)(NSError *))aFailureHandler {
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:businessId/claim"
                                                                                 verb:@"POST"]
                                        forMethod:@"businesses.claim"];
    LBModelRepository *repository = (LBModelRepository *)[[self class] repository];
    [repository invokeStaticMethod:@"claim"
                        parameters:@{@"businessId": self.id}
                           success:aSuccessHandler
                           failure:aFailureHandler];
}

+(void)listSimilarTo:(NSString *)aBusinessId
               limit:(NSNumber *)aLimit
             success:(void(^)(NSArray *businesses))aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:businessId/similar" verb:@"GET"]
                                        forMethod:@"businesses.similar"];
    LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:@"businesses"];
    [businessData invokeStaticMethod:@"similar"
                          parameters:@{@"businessId": aBusinessId, @"limit" : aLimit}
                             success:^(NSArray *results) {
                                 NSMutableArray *businesses = [[NSMutableArray alloc] init];
                                 for (NSDictionary *result in results) {
                                     [businesses addObject:[[Business alloc] initWithDictionary:result]];
                                 }

                                 aSuccessHandler([[NSArray alloc] initWithArray: businesses]);
                             }
                             failure:^(NSError *error) {
                                 aFailureHandler(error);
                             }];
}

+(void)getById:(NSString *)anId
   withSuccess:(void (^)(Business *))aSuccessHandler
       failure:(void (^)(NSError *))aFailureHandler
{
    // we can't simply rely on the findById method as we need to initialize
    // the result model using the initWithDictionary method
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:businessId"
                                                                                 verb:@"GET"]
                                        forMethod:@"businesses.getById"];

    [[[self class] repository] invokeStaticMethod:@"getById"
                                       parameters:@{@"businessId": anId}
                                          success:^(id value) {
                                              aSuccessHandler([[[self class] alloc] initWithDictionary:value]);
                                          }
                                          failure:aFailureHandler];
}



+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessRepository class]];
}

@end