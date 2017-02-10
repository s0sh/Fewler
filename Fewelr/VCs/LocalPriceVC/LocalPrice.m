//
//  LocalPrice.m
//  Fewelr
//
//  Created by developer on 20/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "LocalPrice.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "emsCapModelVC.h"
#import "emsSettingsVC.h"
#import "JTProgressHUD.h"
#import "ApiCall.h"
#import "ModalClass.h"
#import "Reachability.h"
@interface LocalPrice ()

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@property (weak, nonatomic) IBOutlet UIImageView *costImage;

@end

@implementation LocalPrice


-(void)viewWillAppear:(BOOL)animated{
    
     [super viewWillAppear:YES];
    
    
    [JTProgressHUD show];
}
-(void)viewDidAppear:(BOOL)animated{
    
     [super viewDidAppear:YES];
    
    [JTProgressHUD hide];
    

    
    
    if (![self connected]) {
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the Connection to the Internet"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }else{
    
    [[ApiCall sharedInstance] getLocalPrice:^(NSString *price) {
        
        [ModalClass sharedInstance].prise = price ;
        self.placeLabel.text =price;
        self.placeLabel.text = [self.placeLabel.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        self.placeLabel.attributedText =[self styleSalePriceLabel:self.placeLabel.text withFont:self.placeLabel.font];
        self.costImage.hidden = NO;
        self.pLabel.hidden = NO;
         self.placeLabel.hidden = NO;
        [JTProgressHUD hide];
        
        

        
        [ModalClass sharedInstance].localPrice = price;
    } resultFailed:^(NSString *error) {
        
       self.costImage.hidden = NO;
        [JTProgressHUD hide];
    }];
    
    }
    self.pLabel.text = [ModalClass sharedInstance].placeName ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSMutableAttributedString *)styleSalePriceLabel:(NSString *)salePrice withFont:(UIFont *)font
{
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

-(IBAction)capModel:(id)sender
{
    
    if (self.placeLabel.text.length) {
         [APP pushVC:[[emsCapModelVC alloc] init]];
    }
    
   
}



-(IBAction)back
{

  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)settingAction:(id)sender
{
    [self presentViewController:[[emsSettingsVC alloc] init] animated:YES completion:^{
        
    }];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
