//
//  AppDelegate.m
//  Fewelr
//
//  Created by developer on 19/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "emsLoginVC.h"
#import "emsCarMapVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "emsCarMapVC.h"
#import "ModalClass.h"
#import <Stripe/Stripe.h>
#import "EMSDataHandler.h"
#import "emsOrderDetailsVC.h"
#import "ModalClass+RuntimeStorage.h"
NSString *const APPDManagerDidRecieveNotification = @"APPDManagerDidRecieveNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate



NSString * const StripePublishableKey = @"pk_live_m2KzjYovMvzWesA5pCTywKNq";

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
    self.deviceToken = token;
    
    NSString* deviceToken1 = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    NSLog(@"Device_Token     -----> %@\n",deviceToken1);
}
-(void)setupPushes
{

}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [[EMSDataHandler sharedInstance] storeData:nil forKey:kDataManagerFromPushKeyConst];
    NSDictionary *dictToPass = userInfo[@"aps"];
    [[NSNotificationCenter defaultCenter] postNotificationName:APPDManagerDidRecieveNotification object:dictToPass];
    
}
-(BOOL)backgroundStatePushRecieved:(NSDictionary *)lounchOptions
{

    if (lounchOptions) {//Store push details
        [[EMSDataHandler sharedInstance] storeData:lounchOptions forKey:kDataManagerFromPushKeyConst];
        return YES;
    }
    return NO;

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    application.applicationIconBadgeNumber = 0;
    
    UIViewController* mainVC = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Arise from push?
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if([self backgroundStatePushRecieved:remoteNotificationPayload] || [ModalClass sharedInstance].carBrand.length>0)
    {
        //Go to order details
        mainVC =[[emsOrderDetailsVC alloc] init];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[emsCarMapVC alloc] init]];
        [self.navigationController setNavigationBarHidden:YES];
        self.window.rootViewController = self.navigationController;
        [self.navigationController pushViewController:mainVC animated:NO];
    
    }
    else
    {
        mainVC =[[emsLoginVC alloc] init];
        self.window.rootViewController = mainVC;
    }
    
    //TEST
    [ModalClass sharedInstance];
    [Stripe setDefaultPublishableKey:StripePublishableKey];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                 didFinishLaunchingWithOptions:launchOptions];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)setUpNavigator{
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[emsCarMapVC alloc] init]];
    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController =self.navigationController;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [[ModalClass sharedInstance] populateObjectsFromMemory];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[ModalClass sharedInstance] saveObjectAsDictionaryRepresentation];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[ModalClass sharedInstance] populateObjectsFromMemory];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [[ModalClass sharedInstance] saveObjectAsDictionaryRepresentation];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [[ModalClass sharedInstance] populateObjectsFromMemory];
}

//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//
////    return [[FBSDKApplicationDelegate sharedInstance] application:application
////                                                          openURL:url
////                                                sourceApplication:sourceApplication
////                                                       annotation:annotation];
//
////
////    [GPPSignIn sharedInstance].clientID = @"2941382890-95uclk7q9quk58rm1vq13pav4omb049f.apps.googleusercontent.com";
////    if([GPPURLHandler handleURL:url
////              sourceApplication:sourceApplication
////                     annotation:annotation])
////    {
////
////        return YES;
////
////    }
////
////    if([FBAppCall handleOpenURL:url sourceApplication:sourceApplication])
////    {
////
////        return YES;
////
////    }
////    if([self.instagram handleOpenURL:url])
////    {
////
////        return [self.instagram handleOpenURL:url];
////
////    }
////
////
////    if ([[url scheme] isEqualToString:@"myapp"] == NO)
////        return NO;
////
////    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
////
////    NSString *token = d[@"oauth_token"];
////    NSString *verifier = d[@"oauth_verifier"];
////
////    PromotionViewController *vc = (PromotionViewController *)[[self window] rootViewController];
////    [vc setOAuthToken:token oauthVerifier:verifier];
////
////    return YES;
//
//
////    return [GPPURLHandler handleURL:url
////                  sourceApplication:sourceApplication
////                         annotation:annotation];
//
//
//
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                                      openURL:url
//                                                            sourceApplication:sourceApplication
//                                                                   annotation:annotation];
//
//}
//

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma navigatorContoller
-(void)goToRootController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)makeMapRootController
{
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[emsCarMapVC alloc] init]];
    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController =self.navigationController;
}
-(void)pushVC:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}
@end
