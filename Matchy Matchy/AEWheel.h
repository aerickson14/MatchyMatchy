//
//  AEWheel.h
//  Spinner
//
//  Created by Andrew Erickson on 2/6/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEConstants.h"

@interface AEWheel : SKSpriteNode

+(instancetype) initForLevel: (CGFloat) level;

-(void) handleTouch: (UITouch *) touch;

-(void) start;

-(void) update;

-(NSString *) getItemName;

-(void) setLevel:(CGFloat) level;

-(void) reset;

@end
