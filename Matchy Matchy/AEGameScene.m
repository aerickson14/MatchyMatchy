//
//  AEMyScene.m
//  Spinner
//
//  Created by Andrew Erickson on 2/6/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEGameScene.h"
#import "AEWheel.h"
#import "AEHistory.h"
#import "AEViewController.h"
#import "AEConstants.h"
#import "AEFeedbackGenerator.h"
#import "AEScore.h"
#import "AEScoreBar.h"
#import "AEStartScene.h"
#import "AELevelHelper.h"
#import "AEFeedback.h"


@interface AEGameScene() {
    AEWheel *wheel;
    AEHistory  *history;
    SKLabelNode *feedbackLabel;
    SKLabelNode *countdownLabel;
    AEScoreBar *scoreBar;
    CGFloat currentXp;
    
    BOOL shouldShowTutorial;
}

@end

@implementation AEGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [AEConstants getTealColor];
        
        currentXp = [self getSavedXp];
        shouldShowTutorial = NO;
        
        scoreBar = [AEScoreBar initWithXp: currentXp];
        scoreBar.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-80);
        [self addChild: scoreBar];
        
        history = [AEHistory node];
        history.anchorPoint = CGPointMake(0.5, 0.5);
        history.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-140);
        history.zPosition = 2;
        
        [self addChild: history];
        
        CGFloat curLevel = [AELevelHelper getCurrentLevel: currentXp];
        
        wheel = [AEWheel initForLevel: curLevel];
        wheel.name = @"wheel";
        wheel.anchorPoint = CGPointMake(0, 0.5);
        wheel.position = CGPointMake(0, self.frame.size.height-310);
        
        [self addChild:wheel];
    }
    
    return self;
}

-(void) willMoveFromView:(SKView *)view {
    //NSLog(@"gamescene willMoveFromView");
}

-(void) showTutorial {
    //NSLog(@"gamescene showTutorial");
    AEViewController *viewController = (AEViewController *) self.view.window.rootViewController;
    
    [self runAction: [SKAction waitForDuration:0.5] completion:^ {
        
        [viewController pauseGame: self];
        [viewController showTutorial];
    }];
    
}

-(void) countdownToStart {
    
    countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-Bold"];
    countdownLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    countdownLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-260);
    countdownLabel.fontSize = 200;
    countdownLabel.fontColor = [SKColor whiteColor];
    countdownLabel.zPosition = 10;
    
    SKLabelNode *labelShadow = [SKLabelNode labelNodeWithFontNamed:@"Arial-Bold"];
    labelShadow.name = @"shadow";
    labelShadow.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    labelShadow.position = CGPointMake(4,-4);
    labelShadow.fontSize = 200;
    labelShadow.fontColor = [SKColor blackColor];
    labelShadow.zPosition = -1;
    
    [countdownLabel addChild: labelShadow];
    
    [self addChild: countdownLabel];
    
    [ self runAction: [SKAction waitForDuration:1.0] completion:^{
        [countdownLabel setText:@"3"];
        [(SKLabelNode *)[countdownLabel childNodeWithName:@"shadow"] setText:@"3"];
        [countdownLabel setScale:1.0];
        [self playCountdownSound];
        [countdownLabel runAction:[SKAction scaleTo:0.0 duration:1.0] completion:^{
            [countdownLabel setText:@"2"];
            [(SKLabelNode *)[countdownLabel childNodeWithName:@"shadow"] setText:@"2"];
            [countdownLabel setScale:1.0];
            [self playCountdownSound];
            [countdownLabel runAction:[SKAction scaleTo:0.0 duration:1.0] completion:^{
                [countdownLabel setText:@"1"];
                [(SKLabelNode *)[countdownLabel childNodeWithName:@"shadow"] setText:@"1"];
                [countdownLabel setScale:1.0];
                
                [self playCountdownSound];
                [countdownLabel runAction:[SKAction scaleTo:0.0 duration:1.0] completion:^{
                    [countdownLabel setScale:1.0];
                    
                    [self playCountdownSound];
                    [countdownLabel setText:@"GO"];
                    [(SKLabelNode *)[countdownLabel childNodeWithName:@"shadow"] setText:@"GO"];
                    [countdownLabel runAction:[SKAction scaleTo:0.0 duration:0.5] completion:^{
                        [self runAction: [SKAction performSelector:@selector(startWheel) onTarget:self]];
                    }];
                }];
            }];
        }];
    }];
}

-(void) playCountdownSound {
    [self playSound:@"tick.mp3"];
}

-(void) startWheel {
    [self playMusic];
    
    [wheel start];
}

-(void) animateItemToHistory:(NSString *) itemName {
    SKSpriteNode *item = [SKSpriteNode spriteNodeWithImageNamed: itemName];
    item.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20);
    item.zPosition = 9;
    item.xScale = 2;
    item.yScale = 2;
    
    SKAction *scaleUp = [SKAction scaleTo:4 duration:0.5];
    SKAction *scaleDown = [SKAction scaleTo:1 duration:0.5];
    SKAction *scaleGroup = [SKAction sequence:@[scaleUp, scaleDown]];
    NSInteger offset = ([self currentSlot] - 1) * 70;
    SKAction *moveAction = [SKAction moveTo: CGPointMake(CGRectGetMidX(self.frame) + offset, history.position.y) duration: 1.0];
    
    [self addChild: item];
    
    [item runAction: [SKAction group: @[moveAction, scaleGroup]] completion:^ {
        [history addItem: itemName];
        [item removeFromParent];
        [self checkHistory];
    }];
}

-(void) addItemHistory: (NSString *) itemName {
    [history addItem: itemName];
}

-(void) checkHistory {
    if ([history isFull]) {
        [self gatherScore];
    }
}

-(NSInteger) currentSlot {
    return [history currentSlot];
}

-(void) gatherScore {
    int prevLevel = [AELevelHelper getCurrentLevel: currentXp];
    int points = [history getPointsForLevel: prevLevel];
    int numMatching = [history getNumMatching];
    int numCorrect = [history getNumCorrect];
    [history animatePoints: points];
    [scoreBar addPoints: points];
    int currentLevel = [AELevelHelper getCurrentLevel: (currentXp + points)];
    [self saveXp];
    
    [self showFeedbackForPoints: points matching: numMatching correct: numCorrect prev: prevLevel current: currentLevel];
    
    if (currentLevel > prevLevel) {
        [wheel setLevel:currentLevel];
        [wheel reset];
    }
}

-(void) showFeedbackForPoints: (int) points matching: (int) numMatching correct: (int) numCorrect prev: (int) prevLevel current: (int) currentLevel {
   
    NSString *feedback = [AEFeedbackGenerator getFeedbackForPoints:points matching: numMatching correct: numCorrect prev: prevLevel current: currentLevel];
    
    AEFeedback *feedbackNode = [AEFeedback initWithText: feedback];
    feedbackNode.zPosition = 100;
    [self addChild: feedbackNode];
    
    [feedbackNode animateOpen];
}

- (void) reportScore: (int64_t) highScore {
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: @"matchymatchytotalxp"];
    scoreReporter.value = highScore;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        
        //NSLog(@"Score reported successfully");
        
    }];
    
}

-(void) saveXp {
    currentXp = [scoreBar getScore];
    
    //NSLog(@"Saving xp %ld", (long)xp);
    [defaultsManager saveNumberForKey:@"xp" withValue:currentXp];
    
    [self reportScore: currentXp];
}

-(void) setPaused:(BOOL)paused {
   // NSLog(@"Setting paused from %d to %d", self.isPaused, paused);

    [super setPaused:paused];
}

-(void) setFeedback:(NSString *)feedbackText {
    feedbackLabel.text = feedbackText;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    
    if (CGRectContainsPoint([wheel calculateAccumulatedFrame], touchLocation)) {
        
        [wheel handleTouch: touch];
    }
}

-(void) didMoveToView:(SKView *)view {
    //NSLog(@"gamescen didmovetoview");
    if (currentXp  == 0) {
        [self showTutorial];
        
    }
    
    [self countdownToStart];
}

-(void)update:(CFTimeInterval)currentTime {

    [wheel update];
}

@end
