//
//  PopupView.h
//  Fewelr
//
//  Created by admin on 25.12.15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DictionaryBlock)(NSDictionary* result);

@interface PopupView : UIView

@property (weak, nonatomic) IBOutlet UIView *thankYouForRequestView;
@property (weak, nonatomic) IBOutlet UIView *yourOrderIsReadyView;
@property (weak, nonatomic) IBOutlet UIView *thankYouYourPaymentWasView;

@property (nonatomic, copy) DictionaryBlock completition;
@property (nonatomic, copy) DictionaryBlock completition2;

@property (nonatomic, copy) DictionaryBlock completition3;
@property (nonatomic, copy) DictionaryBlock completition4;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (weak, nonatomic) IBOutlet UILabel *waitingLabel;

-(IBAction)payBtnClick;
-(IBAction)cancelBtnClick;

@end
