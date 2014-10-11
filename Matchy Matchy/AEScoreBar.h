//
//  AEScoreBar.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-27.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AEScoreBar : SKSpriteNode

+(instancetype) initWithXp:(CGFloat) current;

-(CGFloat) getScore;

-(void) addPoints:(CGFloat) points;

-(void) updateScore:(CGFloat) newScore;

@end
