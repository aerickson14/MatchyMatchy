
//
//  AELevelHelper.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-30.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AELevelHelper.h"

@implementation AELevelHelper

+(NSArray *) getMinMaxXpFromXp:(CGFloat) xp {
    
    CGFloat diff = 0;
    CGFloat min = 0;
    CGFloat max = 0;
    
    for(int level=1; level<100; level++) {
        diff = level*100;
        max = min + diff - 1;
        
        if (xp >= min && xp <= max) {
            //NSLog(@"Returning min %f max %f for level %d", min, max, level);
            return @[[NSNumber numberWithFloat:min], [NSNumber numberWithFloat:max], [NSNumber numberWithFloat:level]];
        }
        
        min += diff;
    }
    
    return @[[NSNumber numberWithFloat:min], [NSNumber numberWithFloat:min], [NSNumber numberWithFloat:100]];
}

+(CGFloat) getCurrentLevel:(CGFloat) xp {
    NSArray *minMaxAndLevel = [AELevelHelper getMinMaxXpFromXp:xp];
    
    return [minMaxAndLevel[2] floatValue];
}

+(NSArray *) get:(CGFloat) numRings speedsForLevel:(CGFloat)level {
    NSArray *multipliers = @[@2.0, @1.0 ,@1.5, @2.5];
    
    NSMutableArray *speeds = [[NSMutableArray alloc] init];
    int speedBoost = fmod(level, 10);
    if (speedBoost == 0) speedBoost = 10;
    
    for(int i=0; i<numRings; i++) {
        CGFloat multiplier = [[multipliers objectAtIndex: (i%[multipliers count])] floatValue];
        CGFloat speed =  (multiplier*100) + (25*speedBoost) + 75;
        [speeds addObject: [NSNumber numberWithFloat: speed]];
        //NSLog(@"Ring %d is now at speed %f", (i+1), speed);
    }
    
    return speeds;
}

+(BOOL) shouldShuffle:(CGFloat) level {
    double ten = 10;
    int levelType = floor((level-1)/ten);
    int rem = levelType % 2;
    return (rem == 1);
}

+(CGFloat) numRingsFor:(CGFloat) level {
    double twenty = 20;
    int base = floor((level-1)/twenty);
    int max = MAX(0, base);
    int result = max + 3;
    return result;
}

@end
