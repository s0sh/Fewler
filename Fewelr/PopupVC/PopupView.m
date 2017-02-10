//
//  PopupView.m
//  Fewelr
//
//  Created by admin on 25.12.15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "PopupView.h"
#import "ApiCall.h"
#import "ModalClass.h"
#import "Defines.h"

@implementation PopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"PopupView"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
    }
    return self;
}

- (IBAction)testBtnClick:(id)sender {
    
    NSLog(@"btn clk1");
    
    if (self.completition)
    {
        self.completition(@{@"typeOfProperty":self.completition});
    }
}

- (IBAction)testBtnClick2:(id)sender {
    
    NSLog(@"btn clk3");
    
    if (self.completition2)
    {
        self.completition2(@{@"typeOfProperty":self.completition2});
    }
}

-(IBAction)hidePopup
{
    self.hidden = YES;
}

-(IBAction)payBtnClick
{
    [self hidePopup];
    
    if (self.completition3)
    {
        self.completition3(@{@"typeOfProperty":self.completition3});
    }
}

-(IBAction)cancelBtnClick
{
    [self hidePopup];
    
//    [UIView animateWithDuration:0.4 animations:^{
//        //self.bgViewOrderReadyView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.4 animations:^{
////            self.yourOrderReadyView.frame =CGRectMake( self.alertView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//        } completion:^(BOOL finished) {
//            
            [[ApiCall sharedInstance] clouseOrderResultSuccess:^(NSDictionary *dictionary) {
                
                [ModalClass sharedInstance].currentOrderID = @"";
                [APP goToRootController];
                
                NSLog(@">log cancel success");
            } resultFailed:^(NSString *error) {
                
                NSLog(@">log cancel fail");
            }];
            
//        }];
//    }];
}


@end