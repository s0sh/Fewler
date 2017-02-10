//
//  EMSDataHandler.h
//  Fewelr
//
//  Created by Roman Bigun on 1/15/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDataManagerKeyConst;
extern NSString *const kDataManagerFromPushKeyConst;

@interface EMSDataHandler : NSObject
+(EMSDataHandler *)sharedInstance;
-(void)storeData:(NSDictionary*)dataToStore forKey:(NSString*)key;
-(NSDictionary*)retrieveStoredDataForKey:(NSString*)key;
-(void)storeModalClassAsADictionary;

@end
