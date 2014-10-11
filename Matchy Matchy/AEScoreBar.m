//
//  AEScoreBar.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-27.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEScoreBar.h"
#import "AEConstants.h"
#import "AELevelHelper.h"

@interface AEScoreBar() {
    SKSpriteNode *bar;
    SKLabelNode *levelLabel;
    
    CGFloat minScore;
    CGFloat maxScore;
    CGFloat curScore;
    int curLevel;
}
@end

@implementation AEScoreBar

+(instancetype) initWithXp:(CGFloat) current {
    
    AEScoreBar *node = [AEScoreBar node];
    
    NSArray *minMaxArray = [AELevelHelper getMinMaxXpFromXp: current];
    
    node.minScore = [minMaxArray[0] floatValue];
    node.maxScore = [minMaxArray[1] floatValue];
    node.curLevel = [minMaxArray[2] intValue];
    node.curScore = current;
    node.anchorPoint = CGPointMake(0.5, 0.5);
    [node addBackground];
    
    //NSLog(@"min: %f max: %f cur: %f", [node getMinScore], [node getMaxScore], current);
    
    [node addBar];
    [node setBarTo: 0];
    
    [node addLevelIndicator];
    
    [node updateBarToCurrent];
    
    return node;
}

-(CGFloat) getProgressPct {
    CGFloat range = maxScore - minScore;
    CGFloat progress = curScore - minScore;
    return progress/range;
}

-(void) updateBarToCurrent {
    CGFloat pct = [self getProgressPct];
    //NSLog(@"updating to pct %f", pct);
    
    [self updateBarTo: pct];
}

-(void) updateBarTo:(CGFloat) pct {
    pct = MIN(pct, 1);
    [bar runAction: [SKAction scaleXTo:pct duration:1.0]];
}

-(void) setBarTo:(CGFloat) pct {
    //NSLog(@"setting pct to %f", pct);
    [bar setXScale:pct];
}

-(void) updateScore:(CGFloat) newScore {
   // NSLog(@"Updating score in scorebar to: %f" ,newScore);
    curScore = newScore;
    [self updateBarToCurrent];
}

-(CGFloat) getScore {
    return curScore;
}

-(void) addPoints:(CGFloat)points {
    curScore += points;
    //NSLog(@"Adding %f points to score which is now %f", points, curScore);
    
    if (curScore > maxScore) {
        [self updateLevel];
        [self setBarTo:0];
        [self showLevelAnnouncement];
    }
    
    [self updateBarToCurrent];
}

-(void) showLevelAnnouncement {
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithColor:[AEConstants getOrangeColor] size:CGSizeMake(280, 40)];
    bgNode.anchorPoint = CGPointMake(0.5, 0.5);
    bgNode.xScale = 0;
    bgNode.yScale = 0;
    bgNode.zPosition = 10;
    
    SKLabelNode *levelNotif = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    levelNotif.text = [NSString stringWithFormat:@"Level %d", curLevel];
    levelNotif.color = [SKColor whiteColor];
    levelNotif.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    levelNotif.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    
    SKLabelNode *shadow = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    shadow.color = [SKColor blackColor];
    shadow.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    shadow.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    shadow.position = CGPointMake(1,-1);
    shadow.zPosition = -1;
    shadow.text = [NSString stringWithFormat:@"Level %d", curLevel];
    [levelNotif addChild:shadow];
    
    [bgNode addChild: levelNotif];
    
    SKAction *notifyAction = [SKAction sequence:@[[SKAction scaleTo:1 duration:1], [SKAction waitForDuration:5], [SKAction scaleTo:0 duration:1]]];
    
    [bgNode runAction: notifyAction completion:^{
        [bgNode removeFromParent];
    }];
    
    [self addChild: bgNode];
}

-(void) updateLevel {
    NSArray *minMaxArray = [AELevelHelper getMinMaxXpFromXp:curScore];
    
    minScore = [minMaxArray[0] floatValue];
    maxScore = [minMaxArray[1] floatValue];
    curLevel = [minMaxArray[2] intValue];
    
    levelLabel.text = [NSString stringWithFormat:@"%d", curLevel];
}

-(void) addLevelIndicator {
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 30, 30)];
    
    SKShapeNode *circle = [SKShapeNode node];
    circle.path = circlePath.CGPath;
    circle.fillColor = [AEConstants getOrangeColor];
    circle.strokeColor = [AEConstants getOrangeColor];
    circle.zPosition = 3;
    circle.position = CGPointMake(-155, -15);
    
    [self addChild: circle];
    
    levelLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    levelLabel.text = [NSString stringWithFormat:@"%d", curLevel];
    levelLabel.fontSize = 20;
    levelLabel.fontColor = [SKColor whiteColor];
    levelLabel.zPosition = 4;
    levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    levelLabel.position = CGPointMake(-140, 0);
    
    [self addChild: levelLabel];
}

-(void) addBar {
    
    SKShapeNode *barShape = [SKShapeNode node];
    
    CGMutablePathRef outline = CGPathCreateMutable();
    CGPathMoveToPoint(outline, nil, 0, -10);
    CGPathAddLineToPoint(outline, nil, 290, -10);
    CGPathAddLineToPoint(outline, nil, 290, 10);
    CGPathAddLineToPoint(outline, nil, 0, 10);
    CGPathAddLineToPoint(outline, nil, 0, -10);
    
    barShape.path = outline;
    SKColor *orange = [AEConstants getOrangeColor];
    barShape.fillColor = orange;
    barShape.strokeColor = orange;
    barShape.zPosition = 2;
    barShape.position = CGPointMake(0, 0);
    
    bar = [SKSpriteNode node];
    bar.anchorPoint = CGPointMake(0, 0);
    bar.position = CGPointMake(-150, 0);
    [bar addChild:barShape];
    
    [self addChild: bar];
    
    CGPathRelease(outline);
}

-(void) addBackground {
    
    SKShapeNode *bg = [SKShapeNode node];
    
    CGMutablePathRef outline = CGPathCreateMutable();
    CGPathMoveToPoint(outline, nil, -140, -10);
    CGPathAddLineToPoint(outline, nil, 150, -10);
    CGPathAddLineToPoint(outline, nil, 150, 10);
    CGPathAddLineToPoint(outline, nil, -140, 10);
    CGPathAddLineToPoint(outline, nil, -140, -10);
    
    bg.path = outline;
    SKColor *grey = [AEConstants getGreyColor];
    SKColor *orange = [AEConstants getOrangeColor];
    bg.fillColor = grey;
    bg.strokeColor = orange;
    bg.zPosition = 1;
    bg.position = CGPointMake(0, 0);
    
    [self addChild:bg];
    
    CGPathRelease(outline);
}

-(void) setMinScore:(CGFloat) min {
    minScore = min;
}

-(CGFloat) getMinScore {
    return minScore;
}

-(void) setMaxScore:(CGFloat) max {
    maxScore = max;
}

-(CGFloat) getMaxScore {
    return maxScore;
}

-(void) setCurScore:(CGFloat) cur {
    curScore = cur;
}

-(void) setCurLevel:(CGFloat) level {
    curLevel = level;
}

@end
