//
//  AmountOfGasVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "AmountOfGasVC.h"
#import "LMGaugeView.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "emsDeliveryTimeVC.h"
#import "emsSettingsVC.h"
@interface AmountOfGasVC (){

    LMGaugeView *gaugeView ;
}

@end

@implementation AmountOfGasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    gaugeView = [[LMGaugeView alloc] initWithFrame:CGRectMake(32, 150, 245, 245)];
    gaugeView.value = 10;
    gaugeView.minValue = 10;
    gaugeView.maxValue = 10;
    [self.view addSubview:gaugeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(IBAction)settingAction:(id)sender
{
    [self presentViewController:[[emsSettingsVC alloc] init] animated:YES completion:^{
        
    }];
}


-(IBAction)capModel:(id)sender
{
    [APP pushVC:[[emsDeliveryTimeVC alloc] init]];
}

-(IBAction)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)moreAction:(id)sender{

    gaugeView.value = gaugeView.value +1;
}



-(IBAction)lessAction:(id)sender{
    gaugeView.value = gaugeView.value -1;
    
}

@end
