//
//  PaymentViewController.h
//  Fewelr
//
//  Created by developer on 13/11/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>


@class PaymentViewController;

@protocol PaymentViewControllerDelegate<NSObject>

- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error;

@end
@protocol STPBackendCharging <NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion;

@end



@interface PaymentViewController : UIViewController

@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic, weak) id<STPBackendCharging> backendCharger;
@property (nonatomic, weak) id<PaymentViewControllerDelegate> delegate;
@end
