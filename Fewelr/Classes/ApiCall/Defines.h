//
//  Defines.h
//  Fewelr
//
//  Created by developer on 26/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#ifndef Defines_h
#define Defines_h
#import "AppDelegate.h"


#define kSeerverPath @"http://gasnco.gotests.com"

#define kRegistrationWithMail @"/api/registers/passes/firsts"
#define kLoginWithMail @"/api/registers/passes"
#define kRegistrationModels @"/api/allcars"
#define kCarPicturel @"/api/car/picture"
#define kRegistrationWithFacebooks @"/api/registers/facebooks"
#define kLocalPrice @"/api/price"
#define kRateApp @"/api/reviews"
#define kPostOrder @"/api/orders"
#define kGetActualOrder @"/api/actual/orders"
#define kGetOrderByID @"/api/orderbyid"

#define kUpdateOrderByID @"/api/orders/updates"
#define kPostPayments @"/api/payments"
#define kUpdateUserEmail @"/api/updates/emails"

#define APP (AppDelegate *)[[UIApplication sharedApplication] delegate]

#endif /* Defines_h */
