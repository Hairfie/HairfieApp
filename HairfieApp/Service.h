//
//  Service.h
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Money.h"

@interface Service : NSObject

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *businessId;
@property (strong, nonatomic) NSNumber *durationMinutes;
@property (strong, nonatomic) Money *price;


-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithLabel:(NSString *)aLabel
             price:(Money *)aPrice
          duration:(NSNumber *)aDuration
        businessId:(NSString*)aBusinessId
         serviceId:(NSString*)anId;

-(NSDictionary*)toDictionary;

+(id)fromSetterValue:(id)aValue;


-(void)saveWithSuccess:(void(^)(NSDictionary* result))aSuccessHandler
               failure:(void(^)(NSError *))aFailureHandler;


+(void)deleteService:(NSString*)serviceId
             success:(void(^)())aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler;

@end
