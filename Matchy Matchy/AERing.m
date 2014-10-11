//
//  AERing.m
//  Spinner
//
//  Created by Andrew Erickson on 2/6/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AERing.h"
#import "AERandomHelper.h"
#import "AEScene.h"

@interface AERing() {
    NSMutableArray *graphics;
    int speed;
    BOOL stopped;
}
@end

@implementation AERing

+(instancetype) nodeWithSpeed:(int) initSpeed {
    AERing *node = [AERing node];
    [node setSpeed: initSpeed];
    
    return node;
}

-(id) init {
    if (self = [super init]) {
        graphics = [[NSMutableArray alloc] init];
        stopped = false;
    }
    return self;
}

-(void) setSpeed:(int) newSpeed {
    speed = newSpeed;
}

-(void) setToStopped {
    if (!stopped) {
        [[self getScene] playSound: @"blop.mp3"];
    }
    
    stopped = YES;
}

-(AEScene *) getScene {
    return (AEScene *)self.scene;
}

-(BOOL) isStopped {
    return stopped;
}

-(void) addGraphic: (AEGraphicNode *) graphic withPictureId: (NSString *) pictureId AndScale: (CGFloat) scale {
    graphic.name = pictureId;
    graphic.xScale = scale;
    graphic.yScale = scale;
    CGFloat xPos = [graphics count] * [graphic calculateAccumulatedFrame].size.width;
    graphic.position = CGPointMake(xPos, 0);
    graphic.anchorPoint = CGPointMake(0.5, 0.5);
    [graphic setUserInteractionEnabled: NO];
    
    [graphics addObject:graphic];
    [self addChild:graphic];
}

-(void) pulseGreen {
    SKAction *pulseAction = [self getPulseAction:[SKColor greenColor] withNum: 3];
    
    for(AEGraphicNode *graphic in graphics) {
        SKCropNode *cropChild = (SKCropNode *)[graphic childNodeWithName: @"cropNode"];
        SKSpriteNode *imageChild = (SKSpriteNode *)[cropChild childNodeWithName: @"imageNode"];
        [imageChild runAction:pulseAction];
    }
}

-(void) pulseRed {
    SKAction *pulseAction = [self getPulseAction:[SKColor redColor] withNum:2];
    
    for(AEGraphicNode *graphic in graphics) {
        SKCropNode *cropChild = (SKCropNode *)[graphic childNodeWithName: @"cropNode"];
        SKSpriteNode *imageChild = (SKSpriteNode *)[cropChild childNodeWithName: @"imageNode"];
        [imageChild runAction:pulseAction];
    }
}

-(SKAction *) getPulseAction: (SKColor *) color withNum: (NSInteger) pulses {
    
    SKAction *colorOn = [SKAction colorizeWithColor: color colorBlendFactor:1 duration:0.1];
    SKAction *resetColor = [SKAction colorizeWithColorBlendFactor:0.0 duration:0.05];
    
    NSMutableArray *sequenceArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<pulses; i++) {
        [sequenceArray addObject:colorOn];
        [sequenceArray addObject:resetColor];
    }
    
    SKAction *sequence = [SKAction sequence: sequenceArray];
    
    return sequence;
}

-(void) stop {
    CGFloat remDistance = 10000;
    CGFloat mid = CGRectGetMidX([self getScreen]);
    //NSLog(@"Attempting to stop at %f", mid);
    
    for(SKSpriteNode *graphic in graphics) {
        CGFloat diff = graphic.position.x - mid;
        
        if (diff >= 0 && diff < remDistance) {
            remDistance = diff;
        }
        
        [graphic removeAllActions];
    }
    
    //NSLog(@"Need to move %f pixels", remDistance);
    
    for(AEGraphicNode *graphic in graphics) {
        CGFloat moveTime = 2*(remDistance/speed);
        SKAction *lockPosition = [SKAction moveByX:-1*remDistance y:0 duration:moveTime];
        SKAction *setStopped = [SKAction performSelector:@selector(setToStopped) onTarget:self];
        SKAction *sequence = [SKAction sequence:@[lockPosition, setStopped]];
        [graphic runAction: sequence];
    }
}

-(void) start {
    stopped = NO;
    
    AEGraphicNode *lastGraphic = [graphics objectAtIndex:[graphics count] - 1];
    CGFloat fullStartX = lastGraphic.position.x;
    CGFloat graphicSize = [lastGraphic calculateAccumulatedFrame].size.width;
    CGFloat fullTime = (fullStartX + graphicSize)/speed;
    //NSLog(@"x start pos is %f", fullStartX);
    
    SKAction *reset = [SKAction moveToX: fullStartX duration:0];
    SKAction *moveFullLeft = [SKAction moveToX: -1*graphicSize duration: fullTime];
    SKAction *loopSequence = [SKAction sequence:@[reset, moveFullLeft]];
    
    for(AEGraphicNode *graphic in graphics) {
        CGFloat dist = abs(graphic.position.x + graphicSize);
        CGFloat time = dist/speed;
        
        SKAction *moveLeft = [SKAction moveToX: -1*graphicSize duration: time];
        SKAction *repeatLoop = [SKAction repeatActionForever:loopSequence];
        
        SKAction *sequence = [SKAction sequence:@[moveLeft, repeatLoop]];
        
        [graphic runAction:sequence];
    }
}

-(NSString *) getRingValue {
    NSString *closestPictureId = @"";
    CGFloat closestDistance = 10000;
    
    for(AEGraphicNode *graphic in graphics) {
        NSArray *pieces = [graphic.name componentsSeparatedByString:@"-"];
        if ([pieces count] > 1) {
            NSString *pictureId = [pieces objectAtIndex:1];
            CGFloat distance = abs(graphic.position.x - CGRectGetMidX(self.scene.frame));
            if (distance < closestDistance) {
                closestPictureId = pictureId;
                closestDistance = distance;
            }
        }
    }
    
    return closestPictureId;
}

-(void) update {
    
}

-(CGRect) getScreen {
    return [[UIScreen mainScreen] bounds];
}

@end
