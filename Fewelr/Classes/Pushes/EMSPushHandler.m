//
//  EMSPushHandler.m
//  Fewelr
//
//  Created by Roman Bigun on 1/15/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "EMSPushHandler.h"
#import "AppDelegate.h"
#import "PopupView.h"
#import "PaymentViewController.h"
#import "EMSDataHandler.h"
@interface EMSPushHandler ()

@property(nonatomic, strong) PopupView *popup;

@end

@implementation EMSPushHandler
+ (EMSPushHandler *)sharedInstance
{
    static EMSPushHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        
    });
    return sharedInstance;
}

-(void)generateStatusFromString:(NSString*)strStatus
{
    if([strStatus isEqualToString:@"confirm"])
        orderState = EMSOrderStateConfirm;
    if([strStatus isEqualToString:@"paid"])
        orderState = EMSOrderStatePaid;
    if([strStatus isEqualToString:@"canceled"])
        orderState = EMSOrderStateCanceled;
        
}
-(id)init
{
    self = [super init];
    
    if(self)
    {
    
        self.popup = [[PopupView alloc] initWithFrame:CGRectMake(20,
                                                                 50,
                                                                 280,
                                                                 280)];
        
        self.popup.completition = ^(NSDictionary *dict){};

        
    }
    
    return self;
}
-(void)registerObserverForInstance:(UIViewController*)curInstance
{
    instance = curInstance;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationHandler:)
                                                 name:APPDManagerDidRecieveNotification
                                               object:nil];
    
}
- (void)notificationHandler:(NSNotification *)notification
{
    [self handleNotificationWithObject:notification.object];
    
}
-(void)emulatePushInBackground
{
    NSDictionary *d = [[EMSDataHandler sharedInstance] retrieveStoredDataForKey:kDataManagerFromPushKeyConst];
    if(d)
    {
       [self handleNotificationWithObject:d];
    }
}
-(void)handleNotificationWithObject:(NSDictionary *)object
{
    
    NSLog(@"Handle Data:%@\n and Place popup in: %@",object,instance);
    
    if(object!=nil)
    {
        
    [self generateStatusFromString:object[@"status"]];
    
    if(instance)
    {
        
        if(orderState == EMSOrderStateConfirm)
        {
            
            
            
            self.popup.thankYouForRequestView.hidden = YES;
            self.popup.thankYouYourPaymentWasView.hidden = YES;
            self.popup.waitingLabel.text = [NSString stringWithFormat:@"%@ %@",
                                            object[@"delivery"],
                                            [object[@"delivery"] isEqualToString:@"1"]?@"hour":@"hours"];
            self.popup.yourOrderIsReadyView.frame = CGRectMake( 0 ,
                                                               self.popup.yourOrderIsReadyView.frame.size.height,
                                                               self.popup.yourOrderIsReadyView.frame.size.width,
                                                               self.popup.yourOrderIsReadyView.frame.size.height);
            
            self.popup.yourOrderIsReadyView.hidden = NO;
            
            
            [UIView animateWithDuration:0.4 animations:^{
                self.popup.yourOrderIsReadyView.frame  = CGRectMake(0,
                                                                    0,
                                                                    self.popup.yourOrderIsReadyView.frame.size.width,
                                                                    self.popup.yourOrderIsReadyView.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    
                }];
            }];
            ///////////////
            
        }
        else if(orderState == EMSOrderStatePaid)
        {
            self.popup.thankYouForRequestView.hidden = YES;
            self.popup.yourOrderIsReadyView.hidden = YES;
            self.popup.thankYouYourPaymentWasView.hidden = NO;
            
            [instance presentViewController:[[PaymentViewController alloc] init] animated:YES completion:^{
                
            }];
        }
        else if(orderState == EMSOrderStateRefund)
        {
            //TODO: remove this and make appropriate dialog box
            
            self.popup.thankYouForRequestView.hidden = YES;
            self.popup.thankYouYourPaymentWasView.hidden = YES;
            self.popup.waitingLabel.text = [NSString stringWithFormat:@"%@ %@",
                                            object[@"delivery"],
                                            [object[@"delivery"] isEqualToString:@"1"]?@"hour":@"hours"];
            self.popup.yourOrderIsReadyView.frame = CGRectMake( 0 ,
                                                               self.popup.yourOrderIsReadyView.frame.size.height,
                                                               self.popup.yourOrderIsReadyView.frame.size.width,
                                                               self.popup.yourOrderIsReadyView.frame.size.height);
            
            self.popup.yourOrderIsReadyView.hidden = NO;
            
            
            [UIView animateWithDuration:0.4 animations:^{
                self.popup.yourOrderIsReadyView.frame  = CGRectMake(0,
                                                                    0,
                                                                    self.popup.yourOrderIsReadyView.frame.size.width,
                                                                    self.popup.yourOrderIsReadyView.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    
                }];
            }];
            
        }
        [instance.view addSubview:self.popup];
        
        self.popup.completition3 = ^(NSDictionary *dict)
        {
             //[weakSelf hidePopup];
        };

    
    }
    }
    
    [[EMSDataHandler sharedInstance] storeData:nil forKey:kDataManagerFromPushKeyConst];
}
@end
