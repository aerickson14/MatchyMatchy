//
//  AELevelHelper.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-30.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AELevelHelper : NSObject

+(NSArray *) getMinMaxXpFromXp:(CGFloat) xp;

+(CGFloat) getCurrentLevel:(CGFloat) xp;

+(NSArray *) get:(CGFloat) numRings speedsForLevel:(CGFloat)level;

+(BOOL) shouldShuffle:(CGFloat) level;

+(CGFloat) numRingsFor:(CGFloat) level;

@end
