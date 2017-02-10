//
//  emsLoginVC.m
//  Fewelr
//
//  Created by developer on 20/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsLoginVC.h"
#import "emsRegistrationVC.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "emsRegistrationVC.h"
#import "Defines.h"
#import "ApiCall.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "ModalClass.h"

@interface emsLoginVC ()

@property (nonatomic, strong) NSMutableString *fbTokenString;
@property (nonatomic, strong) NSMutableString *fbUserID;

@property (nonatomic, weak) IBOutlet UIView *enterEmailView;
@property (nonatomic, weak) IBOutlet UIView *bgEnterEmailView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;


@property (nonatomic, weak) IBOutlet UIButton *emailButton;
@end

@implementation emsLoginVC

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.emailField.text.length)
    {
        [self enterEmail];
    }
    
    return NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fbTokenString = [[NSMutableString alloc] init];
    self.fbUserID = [[NSMutableString alloc] init];
    
    [self.view addSubview:self.enterEmailView];
    self.enterEmailView.hidden = YES;
}

-(void)setUpEnterEmailView{
    
    self.enterEmailView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.enterEmailView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.enterEmailView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgEnterEmailView.alpha = 1;
        }];
    }];
}

-(void)hideEnterEmailView{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgEnterEmailView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.enterEmailView.frame =CGRectMake( self.enterEmailView.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
            
        }];
    }];
    
    [self.emailField resignFirstResponder];
}


-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 
                 NSString *fbUserEmail = result[@"email"];
                 NSLog(@">mail: %@", fbUserEmail);
                 
                 if (fbUserEmail || [self checkMarkerThatEmailAlreadyHadBeenSentToTheServer])
                 {
                     NSLog(@"email ne nuzhen");

/**************** comment this block to simulate lack of email address ******************/
                     
                     [[ApiCall sharedInstance] registrationWithFaceBook:self.fbTokenString
                                                                AndFBID:self.fbUserID
                                                          resultSuccess:^(NSDictionary *token) {
                                                              
                                                              if ([[NSString stringWithFormat:@"%@",token[@"success"]] isEqualToString:@"1"] ) {
                                                                  
                                                                  [ModalClass sharedInstance].serverToken = token[@"restToken"];
                                                                  
                                                                  if ([self checkMarkerThatEmailAlreadyHadBeenSentToTheServer])
                                                                  {
                                                                      [APP makeMapRootController];
                                                                  }
                                                                  else
                                                                  {
                                                                      [[ApiCall sharedInstance] updateUserEmail: self.emailField.text
                                                                                                  resultSuccess:^(NSDictionary *success) {
                                                                                                      
                                                                                                      NSLog(@">emailSentOk");
                                                                                                      
                                                                                                      [self setMarkerThatEmailAlreadyHadBeenSentToTheServer:self.emailField.text];
                                                                                                      [APP makeMapRootController];
                                                                                                  }
                                                                                                   resultFailed:^(NSString * fail) {
                                                                                                       
                                                                                                       NSLog(@">emailSentFail");
                                                                                                   }];
                                                                  }
                                                              }
                                                          } resultFailed:^(NSString *fail) {
                                                              
                                                          }];
                     
/****************************************************************************************/
                     
/**************** uncomment this block to simulate lack of email address ******************/
                     
//                     NSLog(@"fbuseremail1");
//                     [self setUpEnterEmailView];
//                     [self.emailField becomeFirstResponder];
                     
/****************************************************************************************/
                     
                 }
                 else
                 {
                     NSLog(@"email NUZHEN");
                     //show email popup
                     NSLog(@"fbuseremail2");
                     [self setUpEnterEmailView];
                     [self.emailField becomeFirstResponder];
                 }
                 
                 
                 
                 
                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}


- (IBAction)loginButtonClicked:(id)sender {
    
    
    if (![self connected]) {
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the Сonnection to the Internet"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }else{
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {

            self.fbTokenString = [result.token.tokenString mutableCopy];
            self.fbUserID = [result.token.userID mutableCopy];
            
            [self fetchUserInfo];
            
        }];
    }
}


-(IBAction)mapAction:(id)sender{
    
    
    [APP makeMapRootController];
}




-(IBAction)registrationWithMail:(id)sender{
    
    [self presentViewController:[[emsRegistrationVC alloc] init] animated:YES completion:^{
        
    }];
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}





- (void) enterEmail
{
    if ([self validateEmail:self.emailField.text]) {
        
        [[ApiCall sharedInstance] registrationWithFaceBook:self.fbTokenString
                                                   AndFBID:self.fbUserID
                                             resultSuccess:^(NSDictionary *token) {
                                                 
                                                 if ([[NSString stringWithFormat:@"%@",token[@"success"]] isEqualToString:@"1"] ) {
                                                     
                                                     [ModalClass sharedInstance].serverToken = token[@"restToken"];
                                                     //////
                                                     
                                                     if ([self checkMarkerThatEmailAlreadyHadBeenSentToTheServer])
                                                     {
                                                         [APP makeMapRootController];
                                                     }
                                                     else
                                                     {
                                                         [[ApiCall sharedInstance] updateUserEmail: self.emailField.text
                                                                                     resultSuccess:^(NSDictionary *success) {
                                                                                         
                                                                                         NSLog(@">emailSentOk");
                                                                                         
                                                                                         
                                                                                         if (![self checkMarkerThatEmailAlreadyHadBeenSentToTheServer])
                                                                                         {
                                                                                             [self setMarkerThatEmailAlreadyHadBeenSentToTheServer:self.emailField.text];
                                                                                         }
                                                                                         
                                                                                         [APP makeMapRootController];
                                                                                     }
                                                                                      resultFailed:^(NSString * fail) {
                                                                                          
                                                                                          NSLog(@">emailSentCancel");
                                                                                      }];
                                                     }
                                                     
                                                     /////
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


- (IBAction)okBtnClick:(id)sender {
    
    [self enterEmail];
}




- (IBAction)cancelBtnClick:(id)sender {
    
    [self hideEnterEmailView];

}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}



- (BOOL) checkMarkerThatEmailAlreadyHadBeenSentToTheServer
{
    BOOL flag = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *emailArray = [userDefaults objectForKey:@"emailArray"];
    
    if (emailArray.count)
    {
        for (NSDictionary *dict in emailArray)
        {
            NSString *fbIdStr = dict[@"fbUserId"];
            
            if ([fbIdStr isEqualToString:self.fbUserID])
            {
                flag = YES;
            }
        }
    }
    
    return flag;
}



- (void) setMarkerThatEmailAlreadyHadBeenSentToTheServer:(NSString *) userEmail
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *emailArray = [[userDefaults objectForKey:@"emailArray"] mutableCopy];
    
    NSDictionary *userFbMailAndFbId = @{ @"fbUserId" :  self.fbUserID,
                                         @"fbUserEmail" :  userEmail };
    
    if (emailArray.count)
    {
        BOOL flag = NO;
        
        for (NSDictionary *dict in emailArray)
        {
            NSString *fbIdStr = dict[@"fbUserId"];
            
            if ([fbIdStr isEqualToString:self.fbUserID])
            {
                flag = YES;
            }
        }
        
        if (!flag)
        {
            [emailArray addObject:userFbMailAndFbId];
        }
    }
    else
    {
            emailArray = [@[userFbMailAndFbId] mutableCopy];
    }
    
    [userDefaults setObject:emailArray  forKey:@"emailArray"];
    
    [userDefaults synchronize];
    
    ////test defaults
    NSArray *testEmailArray = [userDefaults objectForKey:@"emailArray"];
    
    NSLog(@"testmark: %@", testEmailArray);
}



@end
