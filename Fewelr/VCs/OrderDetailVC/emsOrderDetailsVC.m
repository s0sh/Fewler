//
//  emsOrderDetailsVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsOrderDetailsVC.h"
#import "emsSettingsVC.h"
#import "ModalClass.H"
#import "JTProgressHUD.h"
#import "ApiCall.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Defines.h"
#import <Stripe/Stripe.h>
#import "PaymentViewController.h"
#import "EMSPushHandler.h"
#import "EMSDataHandler.h"
@interface emsOrderDetailsVC ()

@property(retain)IBOutlet UIScrollView *scrollFreepost;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UIView *alertView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *myCarImage;
@property (nonatomic, weak) IBOutlet UIImageView *myCarColorImage;
@property (weak, nonatomic) IBOutlet UILabel *myCarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCarColorNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *myCarDiscription;
@property (weak, nonatomic) IBOutlet UILabel *myLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDeliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *myInstructionTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *whatingLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBatton;
@property (weak, nonatomic) IBOutlet UIButton *placeOrder;
@property (nonatomic, weak) IBOutlet UIView *yourOrderReadyView;
@property (nonatomic, weak) IBOutlet UIView *bgViewOrderReadyView;
@property (nonatomic, weak) IBOutlet UIView *thankYouView;
@property (nonatomic, weak) IBOutlet UIView *bgViewThankYou;
@property (strong, nonatomic) IBOutlet UIView *refundQueueView;
@property (weak, nonatomic) IBOutlet UIImageView *bgViewRefundQueueView;
@property (strong, nonatomic) IBOutlet UIView *refundSuccessView;
@property (weak, nonatomic) IBOutlet UIImageView *bgViewRefundSuccessView;
@property (weak, nonatomic) IBOutlet UILabel *thankYouViewLBL;
@property (nonatomic, weak) IBOutlet UIImageView *imageUnder;
//Your order is ready!

@end

@implementation emsOrderDetailsVC


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [[EMSPushHandler sharedInstance] registerObserverForInstance:self];
    
    [JTProgressHUD show];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    [JTProgressHUD hide];
    
    if ([[ModalClass sharedInstance].paymentPaid isEqualToString:@"paymentPaid"]) {
        [self setUpSelfThankYouView];
    }
    if ([[ModalClass sharedInstance].carDeliiveryTime isEqualToString:@"1"]) {
        
        self.whatingLabel.text = [NSString stringWithFormat:@"%@ hour",[ModalClass sharedInstance].carDeliiveryTime];
    }else{
        self.whatingLabel.text = [NSString stringWithFormat:@"%@ hours",[ModalClass sharedInstance].carDeliiveryTime];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self culculetePrice ];
    [self setScroll];
    
    [self.view addSubview:self.alertView];
    self.alertView.hidden = YES;
    
    [self.view addSubview:self.yourOrderReadyView];
    self.yourOrderReadyView.hidden = YES;
    
    
    [self.view addSubview:self.thankYouView];
    self.thankYouView.hidden = YES;
    
    [self.view addSubview:self.refundQueueView];
    self.refundQueueView.hidden = YES;
    
    [self.view addSubview:self.refundSuccessView];
    self.refundSuccessView.hidden = YES;
    
    NSLog(@"%@",self.placeLabel.text);
    
    
    self.placeLabel.text = [self.placeLabel.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    self.placeLabel.attributedText =[self styleSalePriceLabel:self.placeLabel.text withFont:self.placeLabel.font];
    
    self.myCarImage.image = [ModalClass sharedInstance].carImage.image;
    
    if ([ModalClass sharedInstance].carColorImage != nil) {
        self.myCarColorImage.image = [ModalClass sharedInstance].carColorImage.image;
    }
    self.myCarNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[ModalClass sharedInstance].carBrand ,[ModalClass sharedInstance].carModel ,[ModalClass sharedInstance].carYear];
    self.myCarColorNameLabel.text = [ModalClass sharedInstance].carColorName;
    self.myCarDiscription.text =[ModalClass sharedInstance].carDescription;
    
    self.myLicenseLabel.text =[ModalClass sharedInstance].licenseNumber;
    self.myPhoneLabel.text =[ModalClass sharedInstance].phoneNumber;
    
    self.myDeliveryTimeLabel.text =[ModalClass sharedInstance].carDeliiveryTime;
    self.myInstructionTextView.text =[ModalClass sharedInstance].carSpeshiallInstracton;
    
    //Observer
    [[EMSPushHandler sharedInstance] emulatePushInBackground];
    
}

-(NSMutableAttributedString *)styleSalePriceLabel:(NSString *)salePrice withFont:(UIFont *)font
{
    
    if (salePrice.length == 5) {
        
        self.imageUnder.frame = CGRectMake(self.imageUnder.frame.origin.x -24 , self.imageUnder.frame.origin.y, self.imageUnder.frame.size.width, self.imageUnder.frame.size.height);
        
        salePrice = [salePrice substringToIndex:[salePrice length] - 1];
        
        NSRange range = {0,salePrice.length } ;
        range.length = 2;
        range.location = salePrice.length - 2;
        NSMutableAttributedString *stylizedPriceLabel = [[NSMutableAttributedString alloc] initWithString:salePrice];
        UIFont *smallFont = [UIFont fontWithName:font.fontName size:(font.pointSize / 2)];
        NSNumber *offsetAmount = @(font.capHeight - smallFont.capHeight);
        [stylizedPriceLabel addAttribute:NSFontAttributeName value:smallFont range:range];
        [stylizedPriceLabel addAttribute:NSBaselineOffsetAttributeName value:offsetAmount range:range];
        return stylizedPriceLabel;
    }
    
    NSRange range = {0,salePrice.length } ;
    range.length = 2;
    range.location = salePrice.length - 2;
    NSMutableAttributedString *stylizedPriceLabel = [[NSMutableAttributedString alloc] initWithString:salePrice];
    UIFont *smallFont = [UIFont fontWithName:font.fontName size:(font.pointSize / 2)];
    NSNumber *offsetAmount = @(font.capHeight - smallFont.capHeight);
    [stylizedPriceLabel addAttribute:NSFontAttributeName value:smallFont range:range];
    [stylizedPriceLabel addAttribute:NSBaselineOffsetAttributeName value:offsetAmount range:range];
    return stylizedPriceLabel;
    
    
}
-(void)setScroll{
    
    [self.scrollFreepost setContentSize:CGSizeMake(self.scrollFreepost.frame.size.width, self.scrollFreepost.frame.size.height)];
    [self.scrollFreepost setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.scrollFreepost];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(IBAction)settingAction:(id)sender
{
    [self presentViewController:[[emsSettingsVC alloc] init] animated:YES completion:^{
        
    }];
}

-(IBAction)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)payAction{
    
    
    if (![self connected]) {
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the Сonnection to the Internet"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }else{
        
        
        
        
        if ([ModalClass sharedInstance].currentOrderID.length) {
            [JTProgressHUD show];
            [[ApiCall sharedInstance] getOrderByIDResultSuccess:^(NSDictionary *dictionary) {
                
                NSLog(@"Success:\n%@",dictionary);
                               
                
                [JTProgressHUD hide];
                if ([[NSString stringWithFormat:@"%@",dictionary[@"order"][@"status"]] isEqualToString:@"new"]) {
                    
                    [self setUpSelf];
                    
                }
                
                if ([[NSString stringWithFormat:@"%@",dictionary[@"order"][@"status"]] isEqualToString:@"confirm"]) {
                    
                    [self presentViewController:[[PaymentViewController alloc] init] animated:YES completion:^{
                        
                    }];
                    
                }
                
                if ([[NSString stringWithFormat:@"%@",dictionary[@"order"][@"status"]] isEqualToString:@"paid"]) {
                    
                    if ([[NSString stringWithFormat:@"%@",dictionary[@"order"][@"confirmedDelivery"]] isEqualToString:@"1"]) {
                        self.whatingLabel.text = [NSString stringWithFormat:@"%@ hour",dictionary[@"order"][@"confirmedDelivery"]];
                        self.thankYouViewLBL.text = [NSString stringWithFormat:@" You fewel will be delivered in %@ hour. Your Fewelr Agent is on the way! Please remember to unlock your ""fewel"" door ",dictionary[@"order"][@"confirmedDelivery"]];
                    }else{
                        self.whatingLabel.text = [NSString stringWithFormat:@"%@ hours",dictionary[@"order"][@"confirmedDelivery"]];
                        self.thankYouViewLBL.text = [NSString stringWithFormat:@" You fewel will be delivered in %@ hours. Your Fewelr Agent is on the way! Please remember to unlock your ""fewel"" door ",dictionary[@"order"][@"confirmedDelivery"]];
                    }
                    
                    [self setUpSelfOrderReadyView];
                    
                }
                
                if ([[NSString stringWithFormat:@"%@",dictionary[@"order"][@"status"]] isEqualToString:@"canceled"]) {
                    
                    
                    [self setUpSelfRefundQueueView];
                    
                }
                
                if ([[NSString stringWithFormat:@"%@",dictionary[@"order"][@"status"]] isEqualToString:@"reject"]) {
                    
                    
                    [self setUpSelfRefundSuccessView];
                    
                }
                
                
            } resultFailed:^(NSString *error) {
                [JTProgressHUD hide];
            }];
            
        }else{
            [JTProgressHUD show];
            [[ApiCall sharedInstance] posOrderResultSuccess:^(NSDictionary *dictionary) {
                [JTProgressHUD hide];
                if ([[NSString stringWithFormat:@"%@",dictionary[@"success"]] isEqualToString:@"1"]) {
                    
                    if (dictionary[@"order"][@"id"]) {
                        
                        //currentOrderStatus;
                        [ModalClass sharedInstance].currentOrderID = [NSString stringWithFormat:@"%@",dictionary[@"order"][@"id"]];
                    }
                    
                    
                    [self setUpSelf];
                    
                    self.backBatton.hidden= YES;
                    
                }else{
                    
                    UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                              message:@"The Order is Not Saved"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles: nil];
                    
                    [warningInternet show];
                    
                    
                }
                
            } resultFailed:^(NSString *error) {
                [JTProgressHUD hide];
            }];
            
            
        }
        
    }
}

-(void)culculetePrice{
    
    double price =10 *[[ModalClass sharedInstance].prise doubleValue] ;
    
    self.placeLabel.text = [NSString stringWithFormat:@"%f",price] ;
    
    if (  self.placeLabel.text.length >5) {
        
        self.placeLabel.text = [self.placeLabel.text substringToIndex:6];
    }
    
    [ModalClass sharedInstance].finalCost =  self.placeLabel.text;
    
}

-(void)setUpSelf{
    
    
    self.alertView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.alertView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgView.alpha = 1;
        }];
    }];
}




-(IBAction)hideLeftHard{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.alertView.frame =CGRectMake( self.alertView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
            
        }];
    }];
    
}


-(void)setUpSelfOrderReadyView{
    
    self.yourOrderReadyView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.yourOrderReadyView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.yourOrderReadyView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgViewOrderReadyView.alpha = 1;
        }];
    }];
}




-(IBAction)hideLeftHardOrderReadyView{
    
    self.yourOrderReadyView.hidden = YES;
    
    [APP goToRootController];
    [ModalClass sharedInstance].currentOrderID = @"";
}



-(IBAction)hideLeftHardOrderReadyViewAtStart{
    
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgViewOrderReadyView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.yourOrderReadyView.frame =CGRectMake( self.alertView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
            [[ApiCall sharedInstance] clouseOrderResultSuccess:^(NSDictionary *dictionary) {
                
                [self setUpSelfRefundQueueView];
                
            } resultFailed:^(NSString *error) {
                
            }];
            
        }];
    }];
    
}





-(void)setUpSelfThankYouView{
    
    [ModalClass sharedInstance].paymentPaid = @"";
    
    self.thankYouView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.thankYouView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.thankYouView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgViewThankYou.alpha = 1;
        }];
    }];
}




-(IBAction)hideLeftHardThankYouView{
    
        [UIView animateWithDuration:0.4 animations:^{
            self.bgViewThankYou.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.thankYouView.frame =CGRectMake( self.alertView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            } completion:^(BOOL finished) {
            
            }];
        }];
    
}

-(void)setUpSelfRefundQueueView{
    
    self.refundQueueView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.refundQueueView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.refundQueueView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgViewRefundQueueView.alpha = 1;
        }];
    }];
    
    
}

-(IBAction)hideRefundQueueView{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgViewRefundQueueView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.refundQueueView.frame =CGRectMake( self.refundQueueView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)setUpSelfRefundSuccessView{
    
    
    
    self.refundSuccessView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.refundSuccessView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.refundSuccessView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgViewRefundSuccessView.alpha = 1;
        }];
    }];
}


-(IBAction)hideRefundSuccessView{
    
    self.refundSuccessView.hidden = YES;
    
    [APP goToRootController];
    [ModalClass sharedInstance].currentOrderID = @"";
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}





@end
