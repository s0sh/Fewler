//
//  PaymentViewController.m
//  Fewelr
//
//  Created by developer on 13/11/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "PaymentViewController.h"
#import "Defines.h"
#import "ApiCall.h"
#import "ModalClass.h"
@interface PaymentViewController ()<STPPaymentCardTextFieldDelegate ,STPBackendCharging>
@property(nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic, weak) IBOutlet UIButton *firstArrow;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

NSString *const BackendChargeURLString = nil; // TODO: replace nil with your own value


NSString *const AppleMerchantId = nil; // TODO: replace nil with your own value




@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(15, 75, CGRectGetWidth(self.view.frame) - 30, 44)];
    
    self.paymentTextField.delegate = self;
    
    
    [self.view addSubview:self.paymentTextField];
    
    // TODO:  Dummie. Hide this line in production.
    [ModalClass sharedInstance].paymentPaid = @"paymentPaid";
    
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)save:(id)sender {
    
    
    if (![Stripe defaultPublishableKey]) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: @"Please specify a Stripe Publishable Key in Constants.m"
                                                    }];
        [self.delegate paymentViewController:self didFinish:error];
        return;
    }
    
    
    
    [[STPAPIClient sharedClient] createTokenWithCard:self.paymentTextField.card
                                          completion:^(STPToken *token, NSError *error) {
                                              
                                              //  [ModalClass sharedInstance].paymentPaid = @"paymentPaid";
                                              
                                              NSLog(@"%@",[ModalClass sharedInstance].finalCost);
                                              
                                              [ModalClass sharedInstance].finalCost = [[ModalClass sharedInstance].finalCost stringByReplacingOccurrencesOfString:@"." withString:@""];
                                              NSLog(@"%@",[ModalClass sharedInstance].finalCost);
                                              
                                              if (error) {
                                                  //[self.delegate paymentViewController:self didFinish:error];
                                              }
                                              [self createBackendChargeWithToken:token
                                                                      completion:^(STPBackendChargeResult result, NSError *error) {
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          if (error) {
                                                                              
                                                                              
                                                                              
                                                                              
                                                                              return;
                                                                          }
                                                                          [self.delegate paymentViewController:self didFinish:nil];
                                                                      }];
                                          }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    
    
    // NSDictionary *chargeParams = @{ @"stripeToken": token.tokenId, @"amount": @"0.00"};
    
    
    
    
    
    [[ApiCall sharedInstance] postPayment:token.tokenId ResultSuccess:^(NSDictionary *dictionary) {
        
        [ModalClass sharedInstance].paymentPaid = @"paymentPaid";
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        
    } resultFailed:^(NSString *error) {
        
        
        
    }];
    
    
    
    //    NSString *name = @"John Doe";
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.stripe.com/v1/recipients"]];
    //    NSString *params = [NSString stringWithFormat:@"%@:&name=%@&type=individual&card=%@",@"pk_live_m2KzjYovMvzWesA5pCTywKNq",name,token.tokenId];
    //    request.HTTPMethod = @"POST";
    //    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    [NSURLConnection sendAsynchronousRequest:request
    //                                       queue:[NSOperationQueue mainQueue]
    //                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //     {
    //         if (error)
    //         {
    //             NSLog(@"ERROR: %@",error);
    //         }
    //         else
    //         {
    //             NSLog(@"%@", response);
    //         }
    //     }];
    //
    
    
    
    
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [manager POST:[@"https://api.stripe.com/v1/application_fees" stringByAppendingString:@"/charge"]
    //       parameters:chargeParams
    //          success:^(AFHTTPRequestOperation *operation, id responseObject) { completion(STPBackendChargeResultSuccess, nil);
    //
    //
    //
    //
    //                 NSLog(@"%@",responseObject);
    //
    //
    //          }
    //          failure:^(AFHTTPRequestOperation *operation, NSError *error) { completion(STPBackendChargeResultFailure, error);
    //
    //
    //
    //
    //              NSLog(@"%@",error);
    //
    //
    //
    //          }];
}

#pragma mark ViewControllerManagement


- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    
    self.firstArrow.enabled = textField.isValid;
}


@end
