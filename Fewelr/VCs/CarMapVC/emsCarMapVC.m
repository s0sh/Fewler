//
//  emsCarMapVC.m
//  Fewelr
//
//  Created by developer on 21/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsCarMapVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "LocalPrice.h"
#import "emsSettingsVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JTProgressHUD.h"
#import "ModalClass+RuntimeStorage.h"
#import "EMSPushHandler.h"

@interface emsCarMapVC ()<UITextFieldDelegate>{
    
    CLLocationManager *locationManager;
    CLLocation *curLocation;
    MKAnnotationView *pinView;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UITextField * placeTextField ;
@property ( nonatomic) NSString *longit;
@property ( nonatomic) NSString *lantitud ;

@property (weak, nonatomic) IBOutlet UIView *viewWithFieald;
@end

@implementation emsCarMapVC


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [JTProgressHUD show];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [JTProgressHUD hide];
    [ModalClass sharedInstance].finalCost = @"";
    [ModalClass sharedInstance].paymentPaid = @"";
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.viewWithFieald.frame =CGRectMake(self.viewWithFieald.frame.origin.x,
                                          self.view.frame.size.height -  keyboardRect.size.height -44,
                                          self.viewWithFieald.frame.size.width ,
                                          self.viewWithFieald.frame.size.height);
    
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    self.viewWithFieald.frame =CGRectMake(self.viewWithFieald.frame.origin.x,
                                          464,
                                          self.viewWithFieald.frame.size.width,
                                          self.viewWithFieald.frame.size.height);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    _mapView.delegate = (id)self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO;
    [self.mapView addGestureRecognizer:recognizer];
    
    [[EMSPushHandler sharedInstance] registerObserverForInstance:self];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        if (![annotation isKindOfClass:[MKUserLocation class]])
        {
            [self.mapView removeAnnotation:annotation];
        }
        
    }
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:touchMapCoordinate];
    [self.mapView addAnnotation:annotation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)localPrise:(id)sender
{
    if (self.placeTextField.text.length) {
        [ModalClass sharedInstance].lonfitude = self.longit;
        
        [ModalClass sharedInstance].lantitude = self.lantitud;
        
        [ModalClass sharedInstance].placeName = self.placeTextField.text;
        
        [APP pushVC:[[LocalPrice alloc] init]];
    }else{
        
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Please, Enter Correct Data"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [warning show];
        
    }
}

-(IBAction)settingAction:(id)sender
{
    [self presentViewController:[[emsSettingsVC alloc] init] animated:YES completion:^{
        
    }];
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    [[[CLGeocoder alloc]init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
        NSString *addressString = [lines componentsJoinedByString:@"\n"];
        
        NSString *string = @"null" ;
        
        addressString= [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare,placemark.thoroughfare  ];
        
        if ([addressString rangeOfString:string].location == NSNotFound) {
            
            self.longit = [NSString stringWithFormat:@"%f",(double)annotation.coordinate.longitude];
            self.lantitud= [NSString stringWithFormat:@"%f",(double)annotation.coordinate.latitude];
            self.placeTextField.text = addressString;
        }
        
    }];
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        pinView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotation"];
        if (!pinView)
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotation"];
            pinView.canShowCallout = NO;
            pinView.image = [UIImage imageNamed:@"map_loc"];
            pinView.calloutOffset = CGPointMake(0, 0);
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)initLicator
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    } else {
        [locationManager startUpdatingLocation]; //Will update location immediately
    }
    
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
           
        } break;
        case kCLAuthorizationStatusDenied: {
            
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake( manager.location.coordinate.latitude ,  manager.location.coordinate.longitude );
    
    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    
    [_mapView addAnnotation:annotation];
    
    double miles=12.0;
    double scalingFactor= ABS( cos(2 * M_PI * manager.location.coordinate.latitude /360.0) );
    MKCoordinateSpan span;
    span.latitudeDelta=miles/69.0;
    span.longitudeDelta=miles/(scalingFactor*69.0);
    MKCoordinateRegion region;
    region.span=span;
    region.center=manager.location.coordinate;
    _mapView.showsUserLocation = YES;
    [_mapView setRegion:region animated:YES];
    [locationManager stopUpdatingLocation];
    
}




@end
