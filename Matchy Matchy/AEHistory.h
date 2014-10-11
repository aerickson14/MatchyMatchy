//
//  AEHistory.h
//  Spinner
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AEHistory : SKSpriteNode

-(void) addItem: (NSString *) itemName;

-(int) getPointsForLevel:(int) level;

-(int) getNumMatching;

-(int) getNumCorrect;

-(void) reset;

-(bool) isFull;

-(NSInteger) currentSlot;

-(void) animatePoints:(int) points;

@end
