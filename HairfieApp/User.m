//
//  User.m
//  HairfieApp
//
//  Created by Leo Martin on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "User.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "HairfieLike.h"
#import "SetterUtils.h"

@implementation User

+(NSString *)EVENT_CHANGED
{
    return @"User.changed";
}

-(void)setPicture:(id)aPicture
{
    _picture = [Picture fromSetterValue:aPicture];
}

-(NSString *)name
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

-(NSString *)displayName
{
    return [NSString stringWithFormat:@"%@ %@.", _firstName, [_lastName substringToIndex:1]];
}

-(NSString *)displayHairfies
{
    if ([self.numHairfies integerValue] < 2) {
        return [NSString stringWithFormat:@"%@ hairfie", self.numHairfies];
    } else {
        return [NSString stringWithFormat:@"%@ hairfies", self.numHairfies];
    }
}

-(NSURL *)pictureUrlWithWidth:(NSNumber *)width height:(NSNumber *)height
{
    
    if(self.picture)
        return [self.picture urlWithWidth:width height:height];
    else
        return [UIColor imageWithColor:[UIColor lightGreyHairfie]];
}

-(NSURL *)pictureUrl
{
    return [self pictureUrlWithWidth:nil height:nil];
}

-(void)setupEventListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hairfieSaved:)
                                                 name:[Hairfie EVENT_SAVED]
                                               object:nil];
}

-(void)clearEventListeners
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setupEventListeners];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = (User *)[[[self class] repository] modelWithDictionary:aDictionary];
    if (self) {
        [self setupEventListeners];
    }
    return self;
}

-(void)dealloc
{
    [self clearEventListeners];
}

-(void)hairfieSaved:(NSNotification *)aNotification
{
    Hairfie *hairfie = aNotification.object;
    if (nil != hairfie.author && [hairfie.author.id isEqualToString:self.id]) {
        
        // an haifie was added to the user, let's reload it
        [self refresh];
    }
}

-(void)refresh
{
    if (nil == self.id) {
        // refresh only works on existing entities, should we throw an exception?
        return;
    }
    
    [[self class] getById:self.id
                  success:^(User *user) {
                      // TODO: complete updated properties
                      self.numHairfies = user.numHairfies;
                      self.picture = user.picture;
                      [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] EVENT_CHANGED]
                                                                          object:self];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"pictureUploaded" object:self];
                      
                  }
                  failure:^(NSError *error) {
                      NSLog(@"Failed to refresh user: %@", error.localizedDescription);
                  }];
}


+(void)addBusinessMember:(NSString *)businessMemberId
       toFavoritesOfUser:(NSString *)userId
                 success:(void (^)())aSuccessHandler
                 failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/favorite-business-members/:businessMemberId"
                                                                                 verb:@"PUT"]
                                        forMethod:@"users.favoriteBusinessMember"];
    
    [[User repository] invokeStaticMethod:@"favoriteBusinessMember"
                               parameters:@{@"userId": userId, @"businessMemberId": businessMemberId}
                                  success:^(id value) {
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}

+(void)removeBusinessMember:(NSString *)businessMemberId
        fromFavoritesOfUser:(NSString *)userId
                    success:(void (^)())aSuccessHandler
                    failure:(void (^)(NSError *))aFailureHandler

{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/favorite-business-members/:businessMemberId"
                                                                                 verb:@"DELETE"]
                                        forMethod:@"users.unfavoriteBusinessMember"];
    
    [[User repository] invokeStaticMethod:@"unfavoriteBusinessMember"
                               parameters:@{@"userId": userId, @"businessMemberId": businessMemberId}
                                  success:^(id value) {
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}


+(void)isBusinessMember:(NSString *)businessMemberId
         favoriteOfUser:(NSString *)userId
                success:(void(^)(BOOL isLiked))aSuccessHandler
                failure:(void(^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/favorite-business-members/:businessMemberId"
                                                                                 verb:@"HEAD"]
                                        forMethod:@"users.isFavoriteBusinessMember"];
    
    [[User repository] invokeStaticMethod:@"isFavoriteBusinessMember"
                               parameters:@{@"userId": userId, @"businessMemberId": businessMemberId}
                                  success:^(id value) {
                                      aSuccessHandler(YES);
                                  }
                                  failure:^(NSError *error) {
                                      NSString *httpString = [[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
                                      NSDictionary *httpDic = [NSJSONSerialization
                                                               JSONObjectWithData: [httpString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options: NSJSONReadingMutableContainers
                                                               error: &error];
                                      int statusCode = (int)[[[httpDic objectForKey:@"error"] objectForKey:@"statusCode"] integerValue];
                                      
                                      if (statusCode == 404) {
                                          // 404 means the like doesn't exist
                                          return aSuccessHandler(NO);
                                      }
                                      
                                      aFailureHandler(error);
                                  }];
}



-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (nil != self.id) {
        [parameters setObject:self.id forKey:@"id"];
    }
    [parameters setObject:self.firstName forKey:@"firstName"];
    [parameters setObject:self.lastName forKey:@"lastName"];
    [parameters setObject:self.gender forKey:@"gender"];
   
    if ([self.gender isEqualToString: NSLocalizedStringFromTable(@"Woman", @"Claim", nil)])
        self.gender = GENDER_FEMALE;
    else
        self.gender = GENDER_MALE;
    
    if (self.language != nil) {
        [parameters setObject:self.language forKey:@"language"];
    }
    if (self.phoneNumber != nil) {
        [parameters setObject:self.phoneNumber forKey:@"phoneNumber"];
    }
    if (self.picture != nil)
    {
       [parameters setObject:[self.picture toApiValue] forKey:@"picture"];
    }
    
   
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        if (nil == self.id) {
            self.id = [result objectForKey:@"id"];
        }
        NSLog(@"result user %@", result);
        aSuccessHandler();
    };
    
    if (nil == self.id) {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users"
                                                                                     verb:@"POST"]
                                            forMethod:@"users.create"];
        NSLog(@"Parameters %@", parameters);

        [[self repository] invokeStaticMethod:@"create"
                                   parameters:parameters
                                      success:onSuccess
                                      failure:aFailureHandler];
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"users.update"];
        
      
        LBModelRepository *repository = (LBModelRepository *)[[self class] repository];
        NSLog(@"Parameters %@", parameters);

        [repository invokeStaticMethod:@"update"
                                   parameters:parameters
                                      success:onSuccess
                                      failure:aFailureHandler];
    }
}

+(void)getById:(NSString *)anId
     success:(void (^)(User *user))aSuccessHandler
     failure:(void (^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:id"
                                                                                 verb:@"GET"]
                                        forMethod:@"users.getById"];
    
    [[[self class] repository] invokeStaticMethod:@"getById"
                                       parameters:@{@"id":anId}
                                          success:^(id value) {
                                              aSuccessHandler([[self.class alloc] initWithDictionary:value]);
                                          }
                                          failure:aFailureHandler];
}

+(void)listHairfieLikesByUser:(NSString *)userId
                        until:(NSDate *)until
                        limit:(NSNumber *)limit
                         skip:(NSNumber *)skip
                      success:(void(^)(NSArray *hairfieLikes))aSuccessHandler
                      failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"userId": userId,
        @"limit": limit,
        @"skip": skip
    }];

    if (nil != until) {
        [parameters setObject:until forKey:@"until"];
    }

    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies"
                                                                                 verb:@"GET"]
                                        forMethod:@"users.getLikedHairfies"];
    
    [[User repository] invokeStaticMethod:@"getLikedHairfies"
                               parameters:parameters
                                  success:^(NSArray *results) {
                                      NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                                      for (NSDictionary *result in results) {
                                          [hairfies addObject:[[HairfieLike alloc] initWithDictionary:result]];
                                      }
                                      aSuccessHandler([[NSArray alloc] initWithArray: hairfies]);
                                      
                                  }
                                  failure:aFailureHandler];
}

+(void)isHairfie:(NSString *)hairfieId
     likedByUser:(NSString *)userId
         success:(void(^)(BOOL isLiked))aSuccessHandler
         failure:(void(^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies/:hairfieId"
                                                                                 verb:@"HEAD"]
                                        forMethod:@"users.isLikedHairfie"];
    
    [[User repository] invokeStaticMethod:@"isLikedHairfie"
                               parameters:@{@"userId": userId, @"hairfieId": hairfieId}
                                  success:^(id value) {
                                      aSuccessHandler(YES);
                                  }
                                  failure:^(NSError *error) {
                                      NSString *httpString = [[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
                                      NSDictionary *httpDic = [NSJSONSerialization
                                                               JSONObjectWithData: [httpString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options: NSJSONReadingMutableContainers
                                                               error: &error];
                                      int statusCode = (int)[[[httpDic objectForKey:@"error"] objectForKey:@"statusCode"] integerValue];
                                      
                                      if (statusCode == 404) {
                                          // 404 means the like doesn't exist
                                          return aSuccessHandler(NO);
                                      }
                                      
                                      aFailureHandler(error);
                                  }];
}



+(void)likeHairfie:(NSString *)hairfieId
            asUser:(NSString *)userId
           success:(void (^)())aSuccessHandler
           failure:(void (^)(NSError *))aFailureHandler
{    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies/:hairfieId"
                                                                                 verb:@"PUT"]
                                        forMethod:@"users.likeHairfie"];

    [[User repository] invokeStaticMethod:@"likeHairfie"
                               parameters:@{@"userId": userId, @"hairfieId": hairfieId}
                                  success:^(id value) {
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}


-(void)getManagedBusinessesByUserSuccess:(void (^)())aSuccessHandler
                                 failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/managed-businesses" verb:@"GET"] forMethod:@"users.managed-businesses"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.id forKey:@"userId"];
    
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *business in results) {
            if ([business isKindOfClass:[Business class]]) {
                [temp addObject:business];
            } else {
                [temp addObject:[[Business alloc] initWithDictionary:business]];
            }
        }
        _managedBusinesses = temp;
        aSuccessHandler();
    };
    
    [[User repository] invokeStaticMethod:@"managed-businesses" parameters:parameters success:loadSuccessBlock failure:aFailureHandler];
}

-(BOOL)hasClaimedBusinesses {
    return (_managedBusinesses > 0) ? YES : NO;
}


+(void)unlikeHairfie:(NSString *)hairfieId
            asUser:(NSString *)userId
           success:(void (^)())aSuccessHandler
           failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies/:hairfieId"
                                                                                 verb:@"DELETE"]
                                        forMethod:@"users.unlikeHairfie"];

    [[User repository] invokeStaticMethod:@"unlikeHairfie"
                               parameters:@{@"userId": userId, @"hairfieId": hairfieId}
                                  success:^(id value) {
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}

+(void)loginUserWithEmail:(NSString *)anEmail
              andPassword:(NSString *)aPassword
                  success:(void (^)())aSuccessHandler
                  failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/login" verb:@"POST"] forMethod:@"users.login"];
  
    [[User repository] invokeStaticMethod:@"login" parameters:@{@"email": anEmail, @"password" : aPassword} success:aSuccessHandler failure:aFailureHandler];
}

+(void)signUpUserWithFirstName:(NSString *)aFirstName
                      lastName:(NSString *)aLastName
                         email:(NSString *)anEmail
                      password:(NSString *)aPassword
                        gender:(NSString *)aGender
                      language:(NSString *)aLanguage
                       picture:(NSString *)aPictureUrl
                withNewsletter:(NSNumber *)isNewsletter
                       success:(void (^)(NSDictionary *result))aSuccessHandler
                       failure:(void (^)(NSError *))aFailureHandler {
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:aFirstName forKey:@"firstName"];
    [parameters setObject:aLastName forKey:@"lastName"];
    [parameters setObject:anEmail forKey:@"email"];
    [parameters setObject:aPassword forKey:@"password"];
    [parameters setObject:aGender forKey:@"gender"];
    [parameters setObject:aLanguage forKey:@"language"];
    if (aPictureUrl != nil)
        [parameters setObject:aPictureUrl forKey:@"picture"];

    [parameters setObject:isNewsletter forKey:@"newsletter"];

    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users" verb:@"POST"] forMethod:@"users"];

     [[User repository] invokeStaticMethod:@"" parameters:parameters success:aSuccessHandler failure:aFailureHandler];
}

+(void)recoverPasswordForUserWithEmail:(NSString *)anEmail
                               success:(void (^)(NSDictionary *results))aSuccessHandler
                               failure:(void (^)(NSError *))aFailureHandler {
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/reset" verb:@"POST"] forMethod:@"reset"];
    
    [[User repository] invokeStaticMethod:@"reset" parameters:@{@"email":anEmail} success:aSuccessHandler failure:aFailureHandler];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(UserRepository *)repository
{
    return (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
}

@end