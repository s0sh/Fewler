//
//  emsSettingsVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsSettingsVC.h"
#import <MessageUI/MessageUI.h>
#import "emsTermVC.h"
#import "ApiCall.h"
#import "Reachability.h"

#import "EMSPushHandler.h"

@interface emsSettingsVC ()
@property (nonatomic, retain)NSMutableArray *buttonsArray;
@property (nonatomic, retain)NSMutableArray *imagesArray;
@property (nonatomic, weak) IBOutlet UIButton *firstBtn;
@property (nonatomic, weak) IBOutlet UIButton *secondBtn;
@property (nonatomic, weak) IBOutlet UIView *baseView;
@property (nonatomic, weak) IBOutlet UIView *firstView;
@property (nonatomic, weak) IBOutlet UIView *secondView;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UIImageView *starImage;
@property (nonatomic, weak) IBOutlet UITextView *descriptView;
@end

@implementation emsSettingsVC




- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)sendMail:(id)sender
{

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = (id)self;
        NSArray *usersTo = [NSArray arrayWithObject: @"info@gasn.co"];
        [mail setToRecipients:usersTo];
        [mail setSubject:@""];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@""]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}


- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        
        self.descriptView.frame =CGRectMake(self.descriptView.frame.origin.x,
                                            325,
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
                                          self.baseView.frame.size.height -  keyboardRect.size.height -104,
                                          self.descriptView.frame.size.width ,
                                          self.descriptView.frame.size.height);
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpButtons];
    [self setUpSubviews ];
    
    self.slider.continuous = YES; // NO makes it call only once you let go
    [self.slider addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    [self setImagesArr];
    
    self.starImage.image = [self.self.imagesArray objectAtIndex:0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[EMSPushHandler sharedInstance] registerObserverForInstance:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpSubviews{

    self.secondView.frame = CGRectMake((self.baseView.frame.origin.x + 320), 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    self.firstView.frame = CGRectMake(self.baseView.frame.origin.x, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);

[self.baseView addSubview:self.secondView];
[self.baseView addSubview:self.firstView];
}

-(IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(IBAction)termsAction:(id)sender{

    [self presentViewController:[[emsTermVC alloc] init] animated:YES
                     completion:^{
                         
                     }];
}

-(IBAction)secondBynAction{

    [UIView animateWithDuration:.4 animations:^{
          self.secondView.frame = CGRectMake(0, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
          self.firstView.frame = CGRectMake(320, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
 
}
-(IBAction)firstBynAction{
    
    [UIView animateWithDuration:.4 animations:^{
        self.secondView.frame = CGRectMake(320 , 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
        self.firstView.frame = CGRectMake(0, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}
-(IBAction)selectBTN:(UIButton*)sender{
    
    for (UIButton *btn in self.buttonsArray) {
        [btn setSelected:NO];
    }
    UIButton *btn =(UIButton *)[self.buttonsArray objectAtIndex:sender.tag];
    [btn setSelected:YES];
}

-(void)setUpButtons{
    self.buttonsArray = [[NSMutableArray alloc] init];
    [self.buttonsArray addObject:self.firstBtn];
    [self.buttonsArray addObject:self.secondBtn];

}
-(void)setImagesArr
{
    self.imagesArray = [[NSMutableArray alloc] init];
    [self.imagesArray addObject:[UIImage imageNamed:@"s1"]];
    [self.imagesArray addObject:[UIImage imageNamed:@"s2"]];
    [self.imagesArray addObject:[UIImage imageNamed:@"s3"]];
    [self.imagesArray addObject:[UIImage imageNamed:@"s4"]];
    [self.imagesArray addObject:[UIImage imageNamed:@"s5"]];
    
    
    
}

- (void)valueChanged:(UISlider *)sender {

    NSUInteger index = (NSUInteger)(self.slider.value + 0.5);
    
    self.starImage.image = [self.self.imagesArray objectAtIndex:index];
}



-(IBAction)rateAction:(id)sender{

    int sliderValue= _slider.value +1.5;
    
    if (![self connected]) {
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Check the Connection to the Internet"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }else{
    
    
    [[ApiCall sharedInstance] rateApp:[NSString stringWithFormat:@"%d",sliderValue] AndDescription:self.descriptView.text resultSuccess:^(NSDictionary *succeess) {
        
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Thank You For Rating Your Experience"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];

        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

        
    } resultFailed:^(NSString *error) {
        
    }];
        
    }
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


@end
