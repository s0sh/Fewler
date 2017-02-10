//
//  ApiCall.h
//  Fewelr
//
//  Created by developer on 26/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ApiCall : NSObject

-(void)postPayment:(NSString *)stripeToken ResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)paidOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)clouseOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)getActualOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)posOrderResultSuccess:(void (^)(NSDictionary  *))success resultFailed:(void (^)(NSString *))failed;

-(void)getOrderByIDResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)rateApp:(NSString *)rate AndDescription:(NSString *)description  resultSuccess:(void (^)(NSDictionary  *))success resultFailed:(void (^)(NSString *))failed;

-(void)registrationWithMail:(NSString *)login AndPassword:(NSString *)password  resultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;
-(void)carModelsresultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)getCarImage:(NSString *)carMark AndCarModel:(NSString *)carModel AndcarYear:(NSString *)carYear  resultSuccess:(void (^)(NSString *))success resultFailed:(void (^)(NSString *))failed;

-(void)registrationWithFaceBook:(NSString *)token AndFBID:(NSString *)fbID  resultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed;

-(void)loginWithMail:(NSString *)login
         andPassword:(NSString *)password
             andName:(NSString *)name
       resultSuccess:(void (^)(NSDictionary *))success
        resultFailed:(void (^)(NSString *))failed;

-(void)updateUserEmail:(NSString *)userEmail
         resultSuccess:(void (^)(NSDictionary *))success
          resultFailed:(void (^)(NSString *))failed;


-(void)getLocalPrice:(void (^)(NSString *))price resultFailed:(void (^)(NSString *))failed;

+ (ApiCall *)sharedInstance;
@end
