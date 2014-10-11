//
//  AEDefaultsManager.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-05-21.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEDefaultsManager.h"

@implementation AEDefaultsManager

-(NSInteger) getSavedNumberForKey:(NSString *) key {
    return [[NSUserDefaults standardUserDefaults] integerForKey: key];
}

-(void) saveNumberForKey:(NSString *) key withValue:(NSInteger) value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey: key];
    [defaults synchronize];
}

-(NSString *) getSavedStringForKey:(NSString *) key {
    return [[NSUserDefaults standardUserDefaults] stringForKey: key];
}

-(void) saveValueForKey:(NSString *)key withValue:(id)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue: value forKey:key];
    NSLog(@"Saving value %@ for key %@", value, key);
    [defaults synchronize];
    
}
@end
