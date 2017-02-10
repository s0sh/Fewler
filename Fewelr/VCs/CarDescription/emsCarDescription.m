//
//  emsCarDescription.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsCarDescription.h"
#import "emsCarDetailVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "emsCarDetailVC.h"
#import "emsSettingsVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "JTProgressHUD.h"
#import "ApiCall.h"
#import "ModalClass.h"

@interface emsCarDescription ()
@property (nonatomic, weak) IBOutlet UIImageView* modelView;
@property (nonatomic, weak) IBOutlet UILabel* aboutCarLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptView;
@end



@implementation emsCarDescription




- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        
        self.descriptView.frame =CGRectMake(self.descriptView.frame.origin.x,
                                            368,
                                            self.descriptView.frame.size.width ,
                                            self.descriptView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    [txtView resignFirstResponder];
    return NO;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.descriptView.frame =CGRectMake(self.descriptView.frame.origin.x,
                                        self.view.frame.size.height -  keyboardRect.size.height -104,
                                        self.descriptView.frame.size.width ,
                                        self.descriptView.frame.size.height);
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.descriptView resignFirstResponder];
    
    self.descriptView.frame =CGRectMake(self.descriptView.frame.origin.x,
                                        368,
                                        self.descriptView.frame.size.width ,
                                        self.descriptView.frame.size.height);
    [JTProgressHUD show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [self cornerIm:self.descriptView];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];

    [[ApiCall sharedInstance] getCarImage:[ModalClass sharedInstance].carMarkNiceName AndCarModel:[ModalClass sharedInstance].carModelNiceName AndcarYear:[ModalClass sharedInstance].carYear resultSuccess:^(NSString *success) {
        [ModalClass sharedInstance].carMarkURL = success;
        [self downloadIm:success];
         [JTProgressHUD hide];

    } resultFailed:^(NSString *fail) {
         [JTProgressHUD hide];
    }];
    
    

    self.aboutCarLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[ModalClass sharedInstance].carBrand ,[ModalClass sharedInstance].carModel ,[ModalClass sharedInstance].carYear];
    
}

-(void)downloadIm:(NSString *)urlStr{

    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *urlReq=[NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlReq];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        _modelView.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
    }];
    [requestOperation start];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(IBAction)capModel:(id)sender
{
    
    [ModalClass sharedInstance].carDescription = self.descriptView.text;
    [ModalClass sharedInstance].carImage = _modelView ;

    [APP pushVC:[[emsCarDetailVC alloc] init]];
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

-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius =  4;
    imageView.layer.masksToBounds = YES;
}



@end
