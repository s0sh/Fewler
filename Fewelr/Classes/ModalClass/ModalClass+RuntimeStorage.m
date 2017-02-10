//
//  ModalClass+RuntimeStorage.m
//  Fewelr
//
//  Created by Roman Bigun on 1/16/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "ModalClass+RuntimeStorage.h"
#import "EMSDataHandler.h"
#import <objc/runtime.h>

@implementation ModalClass (RuntimeStorage)

- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}
- (void *)pointerOfIvarForPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty([self class], [name UTF8String]);
    const char *attr = property_getAttributes(property);
    const char *ivarName = strchr(attr, 'V') + 1;
    Ivar ivar = object_getInstanceVariable(self, ivarName, NULL);
    return (char *)self + ivar_getOffset(ivar);
}
-(void)saveObjectAsDictionaryRepresentation {
    
    id current;
   
    NSArray *properties = [self allPropertyNames];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:properties.count];
    for(NSString *name in properties)
    {
        void *propertyIvarAddress = [self pointerOfIvarForPropertyNamed:name];
        current = *(id *)propertyIvarAddress;
        if(![name containsString:@"Image"])
        {
            current = [self valueForKey:name];
            if(current){
               [dictionary setObject:current forKey:name];
            }
        }
        
    }
    NSLog(@"ModalClass properties\n%@",dictionary);
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kDataManagerKeyConst];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
}
-(void)populateObjectsFromMemory
{
    NSLog(@"To restore\n %@",(NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kDataManagerKeyConst]);
    [self setValuesForKeysWithDictionary:(NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kDataManagerKeyConst]];

}

@end
