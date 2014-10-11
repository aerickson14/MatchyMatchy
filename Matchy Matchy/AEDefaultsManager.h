//
//  AEDefaultsManager.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-05-21.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEDefaultsManager : NSObject

-(NSInteger) getSavedNumberForKey:(NSString *) key;

-(void) saveNumberForKey:(NSString *) key withValue:(NSInteger) value;

-(NSString *) getSavedStringForKey:(NSString *) key;

-(void) saveValueForKey:(NSString *) key withValue:(NSString *) value;

@end
