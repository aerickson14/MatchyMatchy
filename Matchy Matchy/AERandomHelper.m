//
//  AERandomHelper.m
//  Runner
//
//  Created by Andrew Erickson on 1/27/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AERandomHelper.h"

@implementation AERandomHelper

+(int) randomNumberBetween:(int)num1 And:(int)num2 {
    int range = abs(num2 - num1);
    
    if (range == 0) return num1;
    
    int randNum = arc4random() % range;
    
    return (num1 < num2) ? (randNum+num1):(randNum+num2);
}

+(CGPoint) randomPointInRect:(CGRect)rect {
    int x = [self randomNumberBetween:rect.origin.x And:rect.origin.x + rect.size.width];
    int y = [self randomNumberBetween:rect.origin.y And:rect.origin.y + rect.size.height];
    
    return CGPointMake(x, y);
}

@end
