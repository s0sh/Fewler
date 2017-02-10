//
//  ModalClass.m
//  Fewelr
//
//  Created by developer on 05/11/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "ModalClass.h"
#import "EMSDataHandler.h"

@implementation ModalClass

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return  self;

}
+ (ModalClass *)sharedInstance
{
    
    static ModalClass * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[self alloc] init];
        
    });
    
    return _sharedInstance;
}


@end
