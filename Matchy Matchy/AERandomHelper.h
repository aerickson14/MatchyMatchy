//
//  AERandomHelper.h
//  Runner
//
//  Created by Andrew Erickson on 1/27/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AERandomHelper : NSObject

+(int) randomNumberBetween: (int) num1 And: (int) num2;

+(CGPoint) randomPointInRect:(CGRect) rect;

@end
