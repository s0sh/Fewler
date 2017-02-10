//
//  ModalClass+RuntimeStorage.h
//  Fewelr
//
//  Created by Roman Bigun on 1/16/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "ModalClass.h"

@interface ModalClass (RuntimeStorage)
-(void)saveObjectAsDictionaryRepresentation;
-(void)populateObjectsFromMemory;
@end
