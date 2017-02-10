//
//  ModalClass.h
//  Fewelr
//
//  Created by developer on 05/11/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ModalClass : NSObject

@property (nonatomic, strong)NSString *serverToken;
@property (nonatomic, strong)NSString *lonfitude;
@property (nonatomic, strong)NSString *lantitude;
@property (nonatomic, strong)NSString *placeName;
@property (nonatomic, strong)NSString *localPrice;
@property (nonatomic, strong)NSString *carBrand;
@property (nonatomic, strong)NSString *carModel;
@property (nonatomic)int selectedModelIndex;
@property (nonatomic)int selectedCarIndex;
@property (nonatomic, strong)NSString *carYear;
@property (nonatomic, strong)NSString * carDescription;
@property (nonatomic, strong)UIImageView *carImage;
@property (nonatomic, strong)UIImageView *carColorImage;
@property (nonatomic, strong)NSString *carColorName;
@property (nonatomic, strong)NSString *licenseNumber;
@property (nonatomic, strong)NSString *phoneNumber;
@property (nonatomic, strong)NSString *carModelNiceName;
@property (nonatomic, strong)NSString *carMarkNiceName;
@property (nonatomic, strong)NSString *carMarkURL;

@property (nonatomic, strong)NSString *carDeliiveryTime;
@property (nonatomic, strong)NSString *carSpeshiallInstracton;

@property (nonatomic, strong)NSString *prise;
@property (nonatomic, strong)NSString *currentOrderID;
@property (nonatomic, strong)NSString *currentOrderStatus;
@property (nonatomic, strong)NSString *paymentPaid;
@property (nonatomic, strong)NSString *finalCost;
+ (ModalClass *)sharedInstance;
@end
