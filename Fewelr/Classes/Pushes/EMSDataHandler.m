//
//  EMSDataHandler.m
//  Fewelr
//
//  Created by Roman Bigun on 1/15/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "EMSDataHandler.h"
#import "ModalClass+RuntimeStorage.h"

@implementation EMSDataHandler

NSString *const kDataManagerKeyConst = @"kCurrentProcessedObject";
NSString *const kDataManagerFromPushKeyConst = @"kDataManagerFromPushKeyConst";

+ (EMSDataHandler *)sharedInstance
{
    static EMSDataHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

-(void)storeData:(NSDictionary*)dataToStore forKey:(NSString*)key
{

    [[NSUserDefaults standardUserDefaults] setObject:dataToStore forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
-(NSDictionary*)retrieveStoredDataForKey:(NSString*)key
{

   return (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:key];

}
@end
