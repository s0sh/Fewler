//
//  emsRegistrationVC.m
//  Fewelr
//
//  Created by developer on 20/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsRegistrationVC.h"
#import "AppDelegate.h"
#import "ApiCall.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "Reachability.h"
#import "JTProgressHUD.h"
#import "ModalClass.h"
@interface emsRegistrationVC ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *loginTF;
@property (nonatomic, weak) IBOutlet UITextField *passTF;
@property (nonatomic, weak) IBOutlet UITextField *confirmPassTF;
@property (nonatomic, weak)  IBOutlet UIButton *loginButton;
@property (nonatomic, weak)  IBOutlet UIButton *joinToUs;
@property (nonatomic)  BOOL ScrollUp;

@end

@implementation emsRegistrationVC




- (void)addBorders:(UITextField *)sender addCornerRadius:(BOOL)cornerRadius
{
    UIColor *color = [UIColor whiteColor];
    sender.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:sender.placeholder
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 
                                                 }
     ];
    
    sender.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f
                                               green:0.0f/255.0f
                                                blue:0.0f/255.0f
                                               alpha:1.0f].CGColor;
    sender.layer.borderWidth = 0.6;
    if(cornerRadius == YES){
        sender.layer.cornerRadius = 4.0;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self scrollMainToUp:YES];
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    //[self scrollMainToUp:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.loginTF.text = nil;
    self.passTF.text = nil;
    self.confirmPassTF.text = nil;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self scrollMainToUp:NO];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.joinToUs setTitle:NSLocalizedString(@"JOIN_TO_US", nil)  forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    self.loginTF.placeholder = @"Email";
    self.passTF.placeholder = @"Password";
    self.confirmPassTF.placeholder = @"Confirm Password";
    [self addBorders:self.loginTF addCornerRadius:YES];
    [self addBorders:self.passTF addCornerRadius:YES];
    [self addBorders:self.confirmPassTF addCornerRadius:YES];
}


- (void)scrollMainToUp:(BOOL)up{
    
    int yUP = 0;
    
    if (up) {
        yUP = 170;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.x- yUP,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height)];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(IBAction)joinToUsPressed{
    
    [self joinToUsToUp:!self.ScrollUp];
}


-(void)joinToUsToUp:(BOOL)up{
    
    int yUP = 0;
    
    if (up) {
        
        yUP = -48;
        
        self.ScrollUp =YES;
        
    }else{
        
        yUP = 48;
        
        self.ScrollUp = NO;
        
        
    }
    
    self.confirmPassTF.hidden = !self.ScrollUp;
    self.ScrollUp?[self.joinToUs setTitle:NSLocalizedString(@"JOIN_TO_LOG_IN", nil) forState:UIControlStateNormal]:
    [self.joinToUs setTitle:NSLocalizedString(@"JOIN_TO_US", nil)  forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.4 animations:^{
        if ( yUP == 48) {
            [self.joinToUs setImage:[UIImage imageNamed:@"log_in_switch"] forState:UIControlStateNormal];
            [self.loginButton setImage:[UIImage imageNamed:@"log_in_btn"] forState:UIControlStateNormal];
        }else{
            
            [self.joinToUs setImage:[UIImage imageNamed:@"sign_up_switch"] forState:UIControlStateNormal];
            [self.loginButton setImage:[UIImage imageNamed:@"sign_up_btn"] forState:UIControlStateNormal];
        }
        
        [self.loginButton setFrame:CGRectMake(self.loginButton.frame.origin.x,
                                              self.loginButton.frame.origin.y- yUP,
                                              self.loginButton.frame.size.width,
                                              self.loginButton.frame.size.height)];
        
    }];
    
}






-(IBAction)loginMail:(id)sender{
    
    
    
    
    if (![self connected]) {
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the Сonnection to the Internet"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
    }
    
    
    if (self.ScrollUp) {
        
        if ([self.passTF.text isEqualToString:self.confirmPassTF.text] ) {
            
            [self registration];
            
        }else{
            
            UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                              message:@"Please, Enter Correct Data"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
            [warning show];
            self.passTF.text = @"";
            self.confirmPassTF.text = @"";
            
        }
        
    }else{
        
        [self login];
    }
    [self.loginTF resignFirstResponder];
    [self.passTF resignFirstResponder];
    [self.confirmPassTF resignFirstResponder];
    [self scrollMainToUp:NO];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([[textField text] length] == 0 && [string isEqualToString:@" "])
    {
        return NO;
        
    }else{
        return YES;
    }
}

-(void)login{
    
    if ([self validateEmail:self.loginTF.text]) {
        
        [JTProgressHUD show];
        
        
        //   [[ApiCall sharedInstance] loginWithMail:self.loginTF.text
        //                               andPassword:self.passTF.text
        //                             resultSuccess:^(NSDictionary *succeess) {
        //    [JTProgressHUD hide];
        //
        //       if ([[NSString stringWithFormat:@"%@",succeess[@"success"]] isEqualToString:@"1"]) {
        //
        //        [APP makeMapRootController];
        //        [ModalClass sharedInstance].serverToken = succeess[@"restToken"];
        //
        //    }
        //
        //    if ([[NSString stringWithFormat:@"%@",succeess[@"success"]] isEqualToString:@"0"]) {
        //
        //        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
        //                                                          message:@"Incorrect Password or Login"
        //                                                         delegate:self
        //                                                cancelButtonTitle:@"OK"
        //                                                otherButtonTitles: nil];
        //        [warning show];
        //    }
        //
        //  } resultFailed:^(NSString *fail) {
        //      [JTProgressHUD hide];
        //  }];
        
        [[ApiCall sharedInstance] loginWithMail:self.loginTF.text
                                    andPassword:self.passTF.text
                                        andName:@"test"
                                  resultSuccess:^(NSDictionary *succeess) {
                                      
                                      [JTProgressHUD hide];
                                      
                                      if ([[NSString stringWithFormat:@"%@",succeess[@"success"]] isEqualToString:@"1"]) {
                                          
                                          [APP makeMapRootController];
                                          [ModalClass sharedInstance].serverToken = succeess[@"restToken"];
                                          
                                      }
                                      
                                      if ([[NSString stringWithFormat:@"%@",succeess[@"success"]] isEqualToString:@"0"]) {
                                          
                                          UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                                                            message:@"Incorrect Password or Login"
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles: nil];
                                          [warning show];
                                      }
                                  }
                                   resultFailed:^(NSString *failed) {
                                       [JTProgressHUD hide];
                                   }];
        
    }else{
        
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Incorrect Email"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [warning show];
        
    }
    
    
}

-(void)registration{
    
    if ([self validateEmail:self.loginTF.text] ) {
        
        
        if (! self.passTF.text.length) {
            
            
            UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                              message:@"Incorrect Password"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
            [warning show];
            return;
            
        }
        
        [JTProgressHUD show];
        
        [[ApiCall sharedInstance] registrationWithMail:self.loginTF.text AndPassword:self.passTF.text resultSuccess:^(NSDictionary *success) {
            
            [JTProgressHUD hide];
            
            if ([[NSString stringWithFormat:@"%@",success[@"success"]] isEqualToString:@"1"]) {
                
                [APP makeMapRootController];
                
                [ModalClass sharedInstance].serverToken = success[@"restToken"];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",success[@"success"]] isEqualToString:@"0"]) {
                
                UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Incorrect Password or Login"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                [warning show];
            }
            
        } resultFailed:^(NSString *fail) {
            
        }];
        
    }else{
        
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Incorrect Email"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [warning show];
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.loginTF becomeFirstResponder];
    
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
