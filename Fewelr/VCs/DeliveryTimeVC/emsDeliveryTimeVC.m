//
//  emsDeliveryTimeVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsDeliveryTimeVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "emsTermsVC.h"
#import "emsOrderDetailsVC.h"
#import "emsSettingsVC.h"
#import "emsTermVC.h"
#import "ModalClass.h"
#import "JTProgressHUD.h"
@interface emsDeliveryTimeVC ()<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *checkTermsBtn;
@property (nonatomic, weak) IBOutlet UITextView *descriptTextView;
@property (nonatomic, weak) IBOutlet UIView *alertView;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, weak) IBOutlet UIButton *whithin_one_hourBtn;
@property (nonatomic, weak) IBOutlet UIButton *whithin_two_hourBtn;
@property (nonatomic, weak) IBOutlet UIButton *whithin_three_hourBtn;
@property (nonatomic, strong)NSString *hours;
@property (nonatomic, retain)NSMutableArray *buttonsArray;

@property (nonatomic) BOOL checkBool;
@end

@implementation emsDeliveryTimeVC



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [JTProgressHUD show];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [JTProgressHUD hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkBool = NO;
    [self.view addSubview:self.alertView];
    self.alertView.hidden = YES;
    [self setUpButtons];
    [self cornerIm:self.descriptTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

-(IBAction)selectBTN:(UIButton*)sender{
    
    for (UIButton *btn in self.buttonsArray) {
        [btn setSelected:NO];
    }
    UIButton *btn =(UIButton *)[self.buttonsArray objectAtIndex:sender.tag];
    [btn setSelected:YES];
    
    self.hours = [NSString stringWithFormat:@"%ld",(long)sender.tag +1];
}
-(void)setUpButtons{
    self.buttonsArray = [[NSMutableArray alloc] init];
    [self.buttonsArray addObject:self.whithin_one_hourBtn];
    [self.buttonsArray addObject:self.whithin_two_hourBtn];
    [self.buttonsArray addObject:self.whithin_three_hourBtn];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.descriptTextView.frame =CGRectMake(self.descriptTextView.frame.origin.x,
                                            self.view.frame.size.height -  keyboardRect.size.height -104,
                                            self.descriptTextView.frame.size.width ,
                                            self.descriptTextView.frame.size.height);
    
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        
        self.descriptTextView.frame =CGRectMake(self.descriptTextView.frame.origin.x,
                                                334,
                                                self.descriptTextView.frame.size.width ,
                                                self.descriptTextView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    [txtView resignFirstResponder];
    return NO;
}
-(IBAction)capModel:(id)sender
{
    
    
    if (self.hours == nil) {
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please,Choose Delivery Time"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        return;
    }
    
    
    
    if ( self.checkBool) {
        
        [ModalClass sharedInstance].carDeliiveryTime = self.hours;
        
        [ModalClass sharedInstance].carSpeshiallInstracton= self.descriptTextView.text;
        
        
        [APP pushVC:[[emsOrderDetailsVC alloc] init]];
    }else{
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the  Terms and Conditions"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }
    
}



-(IBAction)settingAction:(id)sender
{
    [self presentViewController:[[emsSettingsVC alloc] init] animated:YES completion:^{
        
    }];
}

-(IBAction)termsAction:(id)sender{
    
    [self presentViewController:[[emsTermVC alloc] init] animated:YES
                     completion:^{
                         
                     }];
}


-(IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)termsActionCheck:(id)sender{
    
    if (self.checkBool) {
        
        [sender setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        self.checkBool = NO;
        
    }
    
    else{
        [sender setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        self.checkBool = YES;
        
    }
}

-(void)setUpSelf{
    
    
    if (self.hours == nil) {
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please,Choose Delivery Time"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        return;
    }
    
    
    if ( self.checkBool) {
        
        self.alertView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.alertView.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.alertView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.bgView.alpha = 1;
            }];
        }];
        
    }else{
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the  Terms and Conditions"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }
}

-(IBAction)hideLeftHard{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.alertView.frame =CGRectMake( self.alertView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
            [ModalClass sharedInstance].carDeliiveryTime = self.hours;
    
            [ModalClass sharedInstance].carSpeshiallInstracton= self.descriptTextView.text;
            
            [APP pushVC:[[emsOrderDetailsVC alloc] init]];
        }];
    }];
    
}

-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius =  4;
    imageView.layer.masksToBounds = YES;
}


@end
