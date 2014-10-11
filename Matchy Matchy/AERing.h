//
//  AERing.h
//  Spinner
//
//  Created by Andrew Erickson on 2/6/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEGraphicNode.h"

@interface AERing : SKSpriteNode

+(instancetype)nodeWithSpeed:(int) initSpeed;

-(void) addGraphic: (AEGraphicNode *) graphic withPictureId: (NSString *) pictureId AndScale: (CGFloat) scale;

-(void) setSpeed:(int) speed;

-(void) start;

-(void) stop;

-(BOOL) isStopped;

-(NSString *) getRingValue;

-(void) pulseGreen;

-(void) pulseRed;

-(void) update;

@end
