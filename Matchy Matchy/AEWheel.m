//
//  AEWheel.m
//  Spinner
//
//  Created by Andrew Erickson on 2/6/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEWheel.h"
#import "AERing.h"
#import "AEGameScene.h"
#import "AELevelHelper.h"
#import "AERandomHelper.h"
#import "AEGraphicNode.h"

@interface AEWheel() {
    NSMutableArray *rings;
    CGFloat ringScale;
    int numStopped;
    BOOL inMotion;
    BOOL initializing;
    CGFloat curLevel;
}
@end

@implementation AEWheel

+(instancetype)initForLevel:(CGFloat) level {
    //NSLog(@"Creating a wheel for level %f", level);
    AEWheel *wheel = [AEWheel node];
        
    [wheel setUp: level];
    
    return wheel;
}

-(void) setUp:(CGFloat) level {
    numStopped = 0;
    inMotion = NO;
    initializing = YES;
    curLevel = level;
    
    BOOL shuffle = [AELevelHelper shouldShuffle: level];
    int numRings = [AELevelHelper numRingsFor:level];
    ringScale = (numRings==4) ? 1.5:1.5;
    [self addRings: numRings shuffle: shuffle];
    [self addBackground];
    [self addArrows];
}

-(void) addArrows {
    SKShapeNode *arrowDown = [SKShapeNode node];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, -10, 0);
    CGPathAddLineToPoint(path, nil, 10, 0);
    CGPathAddLineToPoint(path, nil, 0, -10);
    CGPathAddLineToPoint(path, nil, -10, 0);
    
    arrowDown.path = path;
    arrowDown.strokeColor = [AEConstants getOrangeColor];
    arrowDown.fillColor = [AEConstants getOrangeColor];
    arrowDown.antialiased = NO;
    arrowDown.position = CGPointMake(160, 104);
    arrowDown.zPosition = 2;
    [self addChild: arrowDown];
    
    CGPathRelease(path);
    
    SKShapeNode *arrowUp = [SKShapeNode node];
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, nil, -10, 0);
    CGPathAddLineToPoint(path2, nil, 10, 0);
    CGPathAddLineToPoint(path2, nil, 0, 10);
    CGPathAddLineToPoint(path2, nil, -10, 0);
    
    arrowUp.path = path2;
    arrowUp.strokeColor = [AEConstants getOrangeColor];
    arrowUp.fillColor = [AEConstants getOrangeColor];
    arrowUp.antialiased = NO;
    arrowUp.position = CGPointMake(160, -104);
    arrowUp.zPosition = 2;
    [self addChild: arrowUp];
    
    CGPathRelease(path2);
}

-(void) addBackground {
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"wheel_background"];
    background.anchorPoint = CGPointMake(0, 0.5);
    background.zPosition = 1;
    
    [self addChild: background];
}

-(void) addRings:(int) numRings shuffle: (BOOL) shuffle {
    
    rings = [[NSMutableArray alloc] init];
    SKSpriteNode *allRingSprites = [SKSpriteNode node];
    allRingSprites.anchorPoint = CGPointMake(0.5, 0.5);
    allRingSprites.zPosition = 2;
    
    NSMutableArray *baseGraphicNames = [AEConstants getGraphicNames];
    NSArray *speeds = [AELevelHelper get:numRings speedsForLevel:curLevel];
    int y = 0;
    
    for(int r=0; r<numRings; r++) {
        NSMutableArray *graphicNames = [AEConstants getGraphicNames];
        int speed = (int) [speeds[r] integerValue];
        AERing *ring = [AERing nodeWithSpeed: speed];
        int h = 0;
        
        for(int i=0; i<numRings-1; i++) {
            [graphicNames addObjectsFromArray: baseGraphicNames];
        }
        
        int g = 0;
        
        if (shuffle) {
            graphicNames = [self shuffleGraphicNames: graphicNames];
        }
        
        for(NSString *graphicName in graphicNames) {
            AEGraphicNode *graphicNode = [AEGraphicNode node];
            int position = (numRings-r-1);
            [graphicNode setImageNamed:graphicName position: position of:numRings];
            if (h==0) h = (graphicNode.frame.size.height*ringScale);
            [ring addGraphic: graphicNode withPictureId: [NSString stringWithFormat:@"%d-%@", r, graphicName] AndScale: ringScale];
            
            g++;
        }
        
        y -= (h + 2);
        //NSLog(@"ring %d height %d y %d", r, h, y);
        ring.position = CGPointMake(0, y);
        ring.anchorPoint = CGPointMake(0, 0.5);
        ring.zPosition = r + 1;
        [ring setUserInteractionEnabled: NO];
        
        [allRingSprites addChild:ring];
        [rings addObject: ring];
    }
    
    allRingSprites.position = CGPointMake(0, -(y/2));
    
    [self addChild:allRingSprites];
    
}

-(NSMutableArray *) get:(int) sections forGraphic: (NSString *) graphicName {
    
    NSMutableArray *graphicSections = [[NSMutableArray alloc] init];
    
    for(int i=0; i<sections; i++) {
        AEGraphicNode *graphicNode = [AEGraphicNode node];
        [graphicNode setImageNamed:graphicName position:i of:sections];
        
        [graphicSections addObject: graphicNode];
    }
    
    return graphicSections;
}

-(NSMutableArray *) shuffleGraphicNames: (NSMutableArray *) graphicNames {
    for (int i = 0; i < 100; i++) {
        int randomInt1 = arc4random() % [graphicNames count];
        int randomInt2 = arc4random() % [graphicNames count];
        [graphicNames exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
    
    return graphicNames;
}

-(void) start {
    [self notifySceneStarted];
    
    for(AERing *ring in rings) {
        [ring start];
    }
    
    inMotion = YES;
    initializing = NO;
}

-(void) handleTouch: (UITouch *) touch {
    
    if (!initializing && !self.isPaused) {
        if (numStopped < [rings count]) {
            [rings[numStopped] stop];
            
            [rings[numStopped] getRingValue];
            numStopped++;
        }
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touches began on wheel");
}

-(void) playWin {
    //NSLog(@"Win detected");
    
    NSMutableArray *pulsesArray = [[NSMutableArray alloc] init];
    
    for(AERing *ring in rings) {
        SKAction *pulseRingAction = [SKAction performSelector:@selector(pulseGreen) onTarget:ring];
        [pulsesArray addObject: pulseRingAction];
    }
    
    
    SKAction *correctSound = [SKAction performSelector:@selector(playCorrectSound) onTarget:self];
    SKAction *pulseRingsGroupAction = [SKAction group:pulsesArray];
    SKAction *waitAction = [SKAction waitForDuration:3.0];
    SKAction *resetAction = [SKAction performSelector:@selector(reset) onTarget: self];
    
    SKAction *winSequence = [SKAction sequence:@[correctSound, pulseRingsGroupAction, waitAction, resetAction]];
    
    [self runAction:winSequence];
}

-(void) playCorrectSound {
    [[self getGameScene] playSound:@"correct.mp3"];
}

-(void) playWrongSound {
    [[self getGameScene] playSound:@"wrong.mp3"];
}

-(void) playLoss {
    //NSLog(@"Loss detected");
    
    NSMutableArray *pulsesArray = [[NSMutableArray alloc] init];
    
    for(AERing *ring in rings) {
        SKAction *pulseRingAction = [SKAction performSelector:@selector(pulseRed) onTarget:ring];
        [pulsesArray addObject: pulseRingAction];
    }
    
    SKAction *wrongSound = [SKAction performSelector:@selector(playWrongSound) onTarget:self];
    SKAction *pulseRingsGroupAction = [SKAction group:pulsesArray];
    SKAction *waitAction = [SKAction waitForDuration:2.0];
    SKAction *resetAction = [SKAction performSelector:@selector(reset) onTarget: self];
    
    SKAction *lossSequence = [SKAction sequence:@[wrongSound, pulseRingsGroupAction, waitAction, resetAction]];
    
    [self runAction:lossSequence];
}

-(void) reset {
    //NSLog(@"Resetting wheel");
    [self removeAllChildren];
    [self setUp: curLevel];
    [self start];
}

-(BOOL) checkForWin {
    NSString *ringValue = @"";
    
    for(AERing *ring in rings) {
        NSString *curRingValue = [ring getRingValue];
        
        if ([ringValue isEqualToString: @""]) ringValue = curRingValue;
        
        if (![curRingValue isEqualToString: ringValue]) return NO;
    }
    
    return YES;
}

-(NSString *) getItemName {
    AERing *ring = [rings objectAtIndex:0];
    NSString *ringValue = [ring getRingValue];
    
    if (![ringValue isEqualToString:@""]) {
        return ringValue;
    }
    
    NSLog(@"Could not find name for item %@", ringValue);
    
    return @"wrong";
}

-(void) notifySceneStopped {
    //[[self getGameScene] enableAds];
}

-(void) notifySceneStarted {
    //[[self getGameScene] disableAds];
}

-(AEGameScene *) getGameScene {
    return (AEGameScene *)self.scene;
}

-(bool) isStopped {
    BOOL allStopped = YES;
    
    for(AERing *ring in rings) {
        [ring update];
        
        allStopped = allStopped && [ring isStopped];
    }
    
    return allStopped;
}

-(void) setLevel:(CGFloat) level {
    curLevel = level;
}

-(void) update {
    
    if (inMotion) {
        
        if ([self isStopped]) {
            inMotion = NO;
            NSString *itemName;
            
            if ([self checkForWin]) {
                [self playWin];
                itemName = [self getItemName];
                [[self getGameScene] animateItemToHistory: itemName];
            } else {
                [self playLoss];
                [[self getGameScene] addItemHistory: @"wrong"];
                [[self getGameScene] checkHistory];
            }
            
            [self notifySceneStopped];
        }
    }
}

@end
