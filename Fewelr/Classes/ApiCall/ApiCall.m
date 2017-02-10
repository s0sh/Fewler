//
//  ApiCall.m
//  Fewelr
//
//  Created by developer on 26/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "ApiCall.h"
#import "Defines.h"
#import "ModalClass.h"
@implementation ApiCall


+ (ApiCall *)sharedInstance
{
    
    static ApiCall * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[ApiCall alloc] init];
        
    });
    
    return _sharedInstance;
}



-(void)postPayment:(NSString *)stripeToken ResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed
{
    
    //POST:
    //    (JSON)
    //    {
    //        "restToken" : "e64775d0d3",
    //        "stripeToken" : "sdfsd0d3"   ,
    //        "amount" : "10000"    IN CENTS !!!!!!! ,
    //        "currency" : "usd"
    //    }
    
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    
    
    
    
    NSInteger costInt = [[ModalClass sharedInstance].finalCost integerValue];
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%ld00",(long)costInt]);
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken,@"restToken",
                        stripeToken,@"stripeToken",
                        [ModalClass sharedInstance].finalCost,@"amount",
                        @"usd",@"currency",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kPostPayments  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        success(responseObject);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        failed(@"error");
        
    }];
    //////
    
//    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
//    
//    
//    
//    
//    NSInteger costInt = 50;//[[ModalClass sharedInstance].finalCost integerValue];
//    
//    
//    NSLog(@">costIn: %@",[NSString stringWithFormat:@"%ld",(long)costInt]);
//    
//    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
//                        [ModalClass sharedInstance].serverToken,@"restToken",
//                        stripeToken,@"stripeToken",
//                        [NSString stringWithFormat:@"%ld",(long)costInt],@"amount",
//                        @"usd",@"currency",
//                        [ModalClass sharedInstance].currentOrderID, @"oId",
//                        nil];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    //manager.securityPolicy.allowInvalidCertificates = YES;
//    
//    
//    [manager POST:kSeerverPath kPostPayments  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        
//        success(responseObject);
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        
//        
//        
//        failed(@"error");
//        
//    }];
    
}




-(void)getOrderByIDResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed{
    
    
    
    //
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        [ModalClass sharedInstance].currentOrderID, @"oId",
                        [ModalClass sharedInstance].currentOrderID, @"oId",
                        [ModalClass sharedInstance].currentOrderID, @"oId",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:kSeerverPath kGetOrderByID  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}

-(void)getActualOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed
{
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:kSeerverPath kGetActualOrder  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        success(responseObject);
        // price(responseObject[@"averagePrice"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}

-(void)posOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed
{
    
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken,@"restToken",
                        [ModalClass sharedInstance].carMarkNiceName,@"carMark",
                        [ModalClass sharedInstance].carModelNiceName,@"carModel",
                        [ModalClass sharedInstance].carYear,@"carYear",
                        [ModalClass sharedInstance].carColorName, @"carColor",
                        [ModalClass sharedInstance].carMarkURL,@"img",
                        [ModalClass sharedInstance].carDeliiveryTime,@"delivery",
                        @"10" ,@"gasAmount",
                        [ModalClass sharedInstance].carDescription, @"description",
                        [ModalClass sharedInstance].placeName ,@"address",
                        [ModalClass sharedInstance].localPrice ,@"price",
                        [ModalClass sharedInstance].lantitude,@"lat",
                        [ModalClass sharedInstance].lonfitude,@"lng",
                        [ModalClass sharedInstance].phoneNumber,@"phoneNumber",
                        [ModalClass sharedInstance].licenseNumber,@"licenseNumber",
                        [ModalClass sharedInstance].carSpeshiallInstracton,@"specialInstructions",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kPostOrder  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}

-(void)clouseOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed
{
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken,@"restToken",
                        [ModalClass sharedInstance].currentOrderID,@"id",
                        @"canceled",@"status",
                        nil];
    
    NSLog(@">ds print: %@", dc);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kUpdateOrderByID  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"clouse sucess!");
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"clouse fail!");
        NSLog(@"why clouse fail?: %@", error.userInfo);
        failed(@"error");
        
    }];
    
}

-(void)paidOrderResultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed
{
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken,@"restToken",
                        [ModalClass sharedInstance].currentOrderID,@"id",
                        @"paid",@"status",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kUpdateOrderByID  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}

-(void)getLocalPrice:(void (^)(NSString *))price resultFailed:(void (^)(NSString *))failed{
    
    NSString *tok = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken]];
    
    
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        @"average", @"class",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:kSeerverPath kLocalPrice  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        price(responseObject[@"averagePrice"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}


-(void)registrationWithFaceBook:(NSString *)token AndFBID:(NSString *)fbID  resultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        
                        fbID, @"facebookId",
                        token, @"facebookToken",
                        @"", @"secondName" ,
                         appDelegate.deviceToken, @"deviceToken",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kRegistrationWithFacebooks  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
    
}

-(void)getCarImage:(NSString *)carMark AndCarModel:(NSString *)carModel AndcarYear:(NSString *)carYear  resultSuccess:(void (^)(NSString *))success resultFailed:(void (^)(NSString *))failed{
    
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        carMark, @"carMark",
                        carModel, @"carModel",
                        carYear, @"carYear",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    // manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:kSeerverPath kCarPicturel  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString * url =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"img"]];
        
        success(url);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}

-(void)carModelsresultSuccess:(void (^)(NSDictionary *))success resultFailed:(void (^)(NSString *))failed{
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    // manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:kSeerverPath kRegistrationModels  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
}


-(void)registrationWithMail:(NSString *)login AndPassword:(NSString *)password  resultSuccess:(void (^)(NSDictionary  *))success resultFailed:(void (^)(NSString *))failed{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        login, @"name",
                        password, @"pass",
                        @"Freddie", @"secondName",
                        appDelegate.deviceToken, @"deviceToken",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kRegistrationWithMail  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}



-(void)rateApp:(NSString *)rate AndDescription:(NSString *)description  resultSuccess:(void (^)(NSDictionary  *))success resultFailed:(void (^)(NSString *))failed{
    
    
    
    NSString *tok = [NSString stringWithFormat:@"%@",[ModalClass sharedInstance].serverToken];
    
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        rate, @"stars",
                        description, @"description",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kRateApp  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        
    }];
    
}


-(void)loginWithMail:(NSString *)login
         andPassword:(NSString *)password
             andName:(NSString *)name
       resultSuccess:(void (^)(NSDictionary *))success
        resultFailed:(void (^)(NSString *))failed{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@">loginWithMail deviceToken: %@", appDelegate.deviceToken);
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        login, @"name",
                        password, @"pass",
                        name, @"secondName",
                        appDelegate.deviceToken, @"deviceToken",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kLoginWithMail  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        NSLog(@">error %@", error);
        
    }];
    
    
}


-(void)updateUserEmail:(NSString *)userEmail
         resultSuccess:(void (^)(NSDictionary *))success
          resultFailed:(void (^)(NSString *))failed{
    

    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        userEmail, @"email",
                        [ModalClass sharedInstance].serverToken, @"restToken",
                        nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:kSeerverPath kUpdateUserEmail  parameters:dc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(@"error");
        NSLog(@">error %", error);
        
    }];
    
    
}





@end
