//
//  AEConstants.m
//  Spinner
//
//  Created by Andrew Erickson on 2014-03-08.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEConstants.h"
#import <SpriteKit/SpriteKit.h>

@implementation AEConstants

+(SKColor *) getTealColor {
    return [SKColor colorWithRed:0 green:0.6157 blue:0.4941 alpha:1];
}

+(SKColor *) getOrangeColor {
    return [SKColor colorWithRed:0.9020 green:0.2862 blue:0.1529 alpha:1];
}

+(SKColor *) getGreyColor {
    return [SKColor colorWithRed:0.8549 green:0.8549 blue:0.8549 alpha:1];
}

+(NSMutableArray *) getGraphicNames {
    return [[NSMutableArray alloc] initWithArray: @[@"mushroom", @"flower", @"star"]];
}

@end
