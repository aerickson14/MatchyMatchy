//
//  AEScore.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AEScore : SKSpriteNode

-(void) addPoints:(NSInteger) points;

-(void) setScore:(NSInteger) score;

-(NSInteger) getScore;

@end
