//
//  emsTermVC.m
//  Fewelr
//
//  Created by developer on 02/11/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsTermVC.h"

@interface emsTermVC ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation emsTermVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString* htmlString= @"http://gasnco.gotests.com/privacy_policy.html";
//    [self.webView loadHTMLString:htmlString baseURL:nil];
//    
    
    NSString *urlAddress = @"http://gasnco.gotests.com/privacy_policy.html";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

-(IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
