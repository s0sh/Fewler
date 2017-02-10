//
//  EMSPushHandler.h
//  Fewelr
//
//  Created by Roman Bigun on 1/15/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(int, EMSOrderState)
{
   EMSOrderStateNew = 1,
   EMSOrderStateConfirm,
   EMSOrderStateClose,
   EMSOrderStateReject,
   EMSOrderStatePaid,
   EMSOrderStateCanceled,
   EMSOrderStateRefund
    
};

@interface EMSPushHandler : NSObject
{
    EMSOrderState orderState;
    UIViewController *instance;
}
+(EMSPushHandler *)sharedInstance;
-(void)registerObserverForInstance:(id)instance;
-(void)emulatePushInBackground;
@end
