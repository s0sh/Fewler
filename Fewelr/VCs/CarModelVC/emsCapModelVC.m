//
//  emsCapModelVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsCapModelVC.h"
#import "emsCarDescription.h"
#import "Defines.h"
#import "emsSettingsVC.h"
#import "AppDelegate.h"
#import "ApiCall.h"
#import "emsCarModel.h"
#import "emsModel.h"
#import "emsYear.h"
#import "emsSelectYearVC.h"
#import "emsSelectModalVC.h"
#import "JTProgressHUD.h"
#import "ModalClass.h"
#import "Reachability.h"
//@property (nonatomic, strong)NSString *carBrand;
//@property (nonatomic, strong)NSString *carModel;
//@property (nonatomic, strong)NSString *carYear;
@interface emsCapModelVC ()<UIPickerViewDataSource,UIPickerViewDataSource>{
    
    BOOL isCustomTipe;
    
    // int selectedCarIndex;
}
@property (nonatomic, retain) NSDictionary *carDictionary;
@property (nonatomic, retain) NSMutableArray *carsArray;
@property (nonatomic, weak) IBOutlet UIPickerView* modelPicker;
@property (nonatomic, weak) IBOutlet UILabel* carBrandLabel;
@property (nonatomic, weak) IBOutlet UITextField* carBrandField;
@property (nonatomic, weak) IBOutlet UILabel* chooseYourCarModelLabel;
@property (nonatomic, weak) IBOutlet UITextField* chooseYourCarModelField;
@property (nonatomic, weak) IBOutlet UILabel* selectYearLabel;
@property (nonatomic, weak) IBOutlet UITextField* selectYearField;


@property (nonatomic, weak) IBOutlet UIButton *firstArrow;
@property (nonatomic, weak) IBOutlet UIButton *secondArrow;


@end

@implementation emsCapModelVC

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [JTProgressHUD show];
    
    self.selectYearLabel.text = [ModalClass sharedInstance].carYear;
    
    self.selectYearField.text = [ModalClass sharedInstance].carYear;
    self.chooseYourCarModelLabel.text  = [ModalClass sharedInstance].carModel;
    
    self.chooseYourCarModelField.text  = [ModalClass sharedInstance].carModel;
    
    self.carBrandField.text  = [ModalClass sharedInstance].carBrand;
}


-(void)parseCars{
    
    self.carsArray= [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in [self.carDictionary objectForKey:@"makes"]) {
        emsCarModel *carModel = [[emsCarModel alloc] init];
        carModel.carModelID = dictionary[@"id"];
        carModel.carModels = [[NSMutableArray alloc] init];
        
        for (NSDictionary *modelDictionary in dictionary[@"models"]) {
            
            
            emsModel *model = [[emsModel alloc] init];
            model.modelID = modelDictionary[@"id"];
            model.years= [[NSMutableArray alloc] init];
            
            for (NSDictionary *yearDictionary in modelDictionary[@"years"]) {
                emsYear *year = [[emsYear alloc] init];
                year.modelyearID= yearDictionary[@"id"];
                year.modelYear = yearDictionary[@"year"];
                [model.years addObject:year];
            }
            
            model.modelName = modelDictionary[@"name"];
            model.modelNiceName = modelDictionary[@"niceName"];
            [carModel.carModels addObject:model];
        }
        carModel.carModelName  = dictionary[@"name"];
        carModel.carModelNiceName  = dictionary[@"niceName"];
        
        [self.carsArray addObject:carModel];
        
    }
    
    emsCarModel *carModel = [[emsCarModel alloc] init];
    carModel.carModelName  = @"Type if not above";
    [self.carsArray addObject:carModel];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self scrollMainToUp:NO];
    return YES;
}
- (void)scrollMainToUp:(BOOL)up{
    
    int yUP = 0;
    
    if (up) {
        yUP = 210;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.x- yUP,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height)];
    }];
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    [self scrollMainToUp:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.carDictionary = [[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
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
        
        
        [[ApiCall sharedInstance] carModelsresultSuccess:^(NSDictionary *succeess) {
            
            self.carDictionary = succeess;
            
            [self parseCars ];
            
            [self.modelPicker reloadAllComponents];
            [JTProgressHUD hide];
        } resultFailed:^(NSString *fail) {
            [JTProgressHUD hide];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

# pragma mark Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.carsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    emsCarModel *carModel = [self.carsArray objectAtIndex:row];
    
    return carModel.carModelName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [ModalClass sharedInstance].selectedCarIndex = (int)row;
    
    isCustomTipe = NO;
    
    self.firstArrow.hidden = NO;
    self.secondArrow.hidden = NO;
    
    self. carBrandField.enabled = NO;
    self. chooseYourCarModelField.enabled = NO;
    self.selectYearField.enabled = NO;
    
    [self.carBrandField resignFirstResponder];
    [self.chooseYourCarModelField resignFirstResponder];
    [self.chooseYourCarModelField resignFirstResponder];
    
    [self scrollMainToUp:NO];
    
    
    self.chooseYourCarModelLabel.text = @"";
    
    self.chooseYourCarModelField.text= @"";
    
    [ModalClass sharedInstance].carYear = @"";
    
    [ModalClass sharedInstance].carModel= @"";
    
    self.selectYearField.text =@"";
    
    emsCarModel *carModel = [self.carsArray objectAtIndex:row];
    if ([carModel.carModels count]) {
        emsModel *model = [carModel.carModels objectAtIndex:0];
        
        
        if ([model.years count]) {
            emsYear *year = [model.years objectAtIndex:0];
            self.selectYearLabel.text =@"";
            self.selectYearField.text =@"";
        }
        
    }
    
    self.carBrandLabel.text = carModel.carModelName;
    self.carBrandField.text = carModel.carModelName;
    [ModalClass sharedInstance].carBrand = carModel.carModelName;
    [ModalClass sharedInstance].carMarkNiceName =carModel.carModelNiceName;
    
    
    if ([carModel.carModelName isEqualToString:@"Type if not above"]) {
        
        isCustomTipe = YES;
        self. carBrandField.enabled = YES;
        self. chooseYourCarModelField.enabled = YES;
        self.selectYearField.enabled = YES;
        self.firstArrow.hidden = YES;
        self.secondArrow.hidden = YES;
    }
    
}


-(IBAction)capModel:(id)sender
{
    
    if ( self.carBrandField.text.length && self.chooseYourCarModelField.text.length &&  self.selectYearField.text.length) {
        
        if (isCustomTipe) {
            [ModalClass sharedInstance].carMarkNiceName  = self.carBrandField.text;
            [ModalClass sharedInstance].carBrand  = self.carBrandField.text;
            [ModalClass sharedInstance].carModelNiceName = self.chooseYourCarModelField.text;
            [ModalClass sharedInstance].carModel = self.chooseYourCarModelField.text;
            [ModalClass sharedInstance].carYear = self.selectYearField.text;
        }
        
        [APP pushVC:[[emsCarDescription alloc] init]];
        
    }else{
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please, Enter All Data"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
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

-(IBAction)selectModelAction
{
    
    emsCarModel *carModel = [self.carsArray objectAtIndex:[ModalClass sharedInstance].selectedCarIndex];
    
    [self presentViewController:[[emsSelectModalVC alloc] initWithModelsArray:carModel.carModels] animated:YES completion:^{
        
    }];
}

-(IBAction)selectYearAction
{
    if (self.chooseYourCarModelField.text.length) {
        
        emsCarModel *carModel = [self.carsArray objectAtIndex:[ModalClass sharedInstance].selectedCarIndex];
        
        emsModel *model =[carModel.carModels objectAtIndex:[ModalClass sharedInstance].selectedModelIndex];
        
        [self presentViewController:[[emsSelectYearVC alloc] initWithYearsArray:model.years] animated:YES completion:^{
            
        }];
    }else{
        
        UIAlertView *warningInternet = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Please, Choose Car Model"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [warningInternet show];
        
    }
    
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
