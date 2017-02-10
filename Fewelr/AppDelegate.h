//
//  AppDelegate.h
//  Fewelr
//
//  Created by developer on 19/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const APPDManagerDidRecieveNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *deviceToken;


-(void)goToRootController;

-(void)makeMapRootController;
-(void)pushVC:(UIViewController *)controller;
@end

