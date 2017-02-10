//
//  emsCarDetailVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsCarDetailVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "emsDeliveryTimeVC.h"
#import "AmountOfGasVC.h"
#import "emsSettingsVC.h"
#import "emsMenuCell.h"
#import "ModalClass.h"
#import "JTProgressHUD.h"
@interface emsCarDetailVC ()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *colorsCollection;
@property (nonatomic, weak) IBOutlet UITextField *colorsTextField;
@property (nonatomic, weak) IBOutlet UITextField *licenseTextField;
@property (nonatomic, weak) IBOutlet UITextField *numberField;
@property (retain, nonatomic) NSMutableArray *colorsArray;
@property(retain)IBOutlet UIScrollView *scrollFreepost;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic) UIImageView *colorImage;
@end

@implementation emsCarDetailVC



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [JTProgressHUD show];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    [JTProgressHUD hide];
    
    
}

-(void)setScroll{
    
    [self.scrollFreepost setContentSize:CGSizeMake(self.scrollFreepost.frame.size.width, self.scrollFreepost.frame.size.height)];
    [self.scrollFreepost setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.scrollFreepost];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


-(void)scrolToTextField:(UITextField *)sender{
    
    [UIView animateWithDuration:0.4f animations:^{
        
        self.scrollFreepost.contentOffset = CGPointMake(self.scrollFreepost.contentOffset.x ,sender.frame.origin.y - 170);
        
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)scrollBack:(UITextField *)sender{
    
    [UIView animateWithDuration:0.4f animations:^{
        
        if (sender.tag ==0) {
            self.scrollFreepost.contentOffset = CGPointMake(self.scrollFreepost.contentOffset.x ,sender.frame.origin.y - 340 );
            
            [ModalClass sharedInstance].carColorImage = nil;
        }
        
        if (sender.tag ==1) {
            self.scrollFreepost.contentOffset = CGPointMake(self.scrollFreepost.contentOffset.x ,sender.frame.origin.y - 380 );
        }
        
        if (sender.tag ==2) {
            self.scrollFreepost.contentOffset = CGPointMake(self.scrollFreepost.contentOffset.x ,sender.frame.origin.y - 420 );
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self scrollBack:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self scrolToTextField:textField];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScroll ];
    [self setColors ];
    
    self.colorsTextField.delegate = (id)self;
    self.colorImage = [[UIImageView alloc] init];
    
    [self.colorsCollection registerClass:[emsMenuCell class] forCellWithReuseIdentifier:@"emsMenuCell"];}


-(void)setColors
{
    
    self.colorsArray =  [[NSMutableArray alloc] init];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"asphalt"],@"colorName":@"Wet Asphalt" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"black"],@"colorName":@"Black" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"blue"],@"colorName":@"Blue Metallic" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"brown"],@"colorName":@"Black Sand" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"green"],@"colorName":@"Green Grass" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"grey"],@"colorName":@"Classic Silver" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"mica"],@"colorName":@"Green Mica" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"orange"],@"colorName":@"Orange" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"perl"],@"colorName":@"Blizzard Perl" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"red"],@"colorName":@"Red Metallica" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"white"],@"colorName":@"Super White" }];
    [self.colorsArray addObject:@{@"image" :[UIImage imageNamed:@"yellow"],@"colorName":@"Yellow Sun" }];
    
    
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
    
    if ( self.colorImage.image!=nil) {
        [ModalClass sharedInstance].carColorImage = self.colorImage;
    }
    
    if (!self.licenseTextField.text.length) {
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please, Enter Your License Plate"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        return;
    }
    
    if (!self.numberField.text.length) {
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please, Enter Your Phone Number"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        return;
    }
    if (self.licenseTextField.text.length < 4) {
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please, Enter  Correct License"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        return;
    }
    if (self.numberField.text.length < 6) {
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please, Enter  Correct Phone Number"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        return;
    }
    
    [ModalClass sharedInstance].carColorName = self.colorsTextField.text;;
    [ModalClass sharedInstance].licenseNumber  = self.licenseTextField.text;
    [ModalClass sharedInstance].phoneNumber = self.numberField.text;
    [APP pushVC:[[AmountOfGasVC alloc] init]];
}



-(IBAction)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.colorsArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"emsMenuCell";
    emsMenuCell *cell = (emsMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.colorImage.image = [self.colorsArray objectAtIndex:indexPath.row][@"image"] ;
    cell.colorName.text = [self.colorsArray objectAtIndex:indexPath.row][@"colorName"] ;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.colorImage.image = [self.colorsArray objectAtIndex:indexPath.row][@"image"];
    self.colorsTextField.text = [self.colorsArray objectAtIndex:indexPath.row][@"colorName"];
}






@end
