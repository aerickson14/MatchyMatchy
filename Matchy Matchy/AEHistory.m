//
//  AEHistory.m
//  Spinner
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEHistory.h"
#import "AEHistoryItem.h"

@interface AEHistory() {
    NSMutableArray *items;
}

@end

@implementation AEHistory

-(id) init {
    if (self = [super init]) {
        items = [[NSMutableArray alloc] init];
        
        for(int i=0; i<3; i++) {
            AEHistoryItem *historyItem = [AEHistoryItem node];
            historyItem.anchorPoint = CGPointMake(0.5, 0.5);
            
            CGFloat w = [historyItem calculateAccumulatedFrame].size.width;
            CGFloat x = (w+10)*(i-1) - 5;
            historyItem.position = CGPointMake(x, 0);
            
            [items addObject: historyItem];
            [self addChild: historyItem];
        }
    }
    return self;
}

-(void) addItem:(NSString *)itemName {
    
    for(AEHistoryItem *item in items) {
        if (![item isSet]) {
            [item setItem: itemName];
            return;
        }
    }
}

-(NSInteger) currentSlot {
    NSInteger i = 1;
    
    for(AEHistoryItem *item in items) {
        if (![item isSet]) return i-1;
        i++;
    }
    
    return [items count];
}

-(bool) isFull {
    
    for(AEHistoryItem *item in items) {
        if (![item isSet]) return NO;
    }
    
    return YES;
}

-(int) getPointsForLevel:(int) level {
    int points = 0;
    
    int numCorrect = [self getNumCorrect];
    
    if (numCorrect == 0) return numCorrect;
    
    int numMatching = [self getNumMatching];
    
    if (numMatching == 3) {
        points += 50*level;
    } else if (numMatching == 2) {
        points += 15*level;
        
        if (numCorrect == 3) points += 5*level;
    } else if (numMatching == 1) {
        if (numCorrect == 3) {
            points += 25*level;
        } else if (numCorrect == 2) {
            points += 5*level;
        } else {
            points += level;
        }
    }
    
    return points;
}

-(int) getNumCorrect {
    int numCorrect = 0;
    
    for(AEHistoryItem *item in items) {
        NSString *itemName = [item getItemName];
        
        if (![itemName isEqualToString: @"wrong"]) {
            numCorrect++;
        }
    }
    
    return numCorrect;
}

-(int) getNumMatching {
    int maxMatches = 0;
    NSMutableDictionary *buckets = [[NSMutableDictionary alloc] init];
    
    for(AEHistoryItem *item in items) {
        NSString *itemName = [item getItemName];
        
        if (![itemName isEqualToString: @"wrong"]) {
            long count = [[buckets objectForKey:itemName] integerValue];
            
            count++;
            
            buckets[itemName] = [NSNumber numberWithLong: count];
        }
    }
    
    for(id key in buckets) {
        long cur = [buckets[key] integerValue];
        
        if (cur > maxMatches) maxMatches = (int)cur;
    }
    
    return maxMatches;
}

-(void) reset {
    
    for(AEHistoryItem *item in items) {
        [item reset];
    }
}

-(void) animatePoints:(int) points {
    SKLabelNode *pointsLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-Bold"];
    pointsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    pointsLabel.position = CGPointMake(0, 0);
    pointsLabel.fontSize = 10;
    pointsLabel.fontColor = [SKColor whiteColor];
    pointsLabel.zPosition = 10;
    pointsLabel.text = [NSString stringWithFormat:@"%d xp", points];
    
    
    SKLabelNode *pointsShadow = [SKLabelNode labelNodeWithFontNamed:@"Arial-Bold"];
    pointsShadow.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    pointsShadow.position = CGPointMake(1, -1);
    pointsShadow.fontSize = 10;
    pointsShadow.fontColor = [SKColor blackColor];
    pointsShadow.zPosition = -1;
    pointsShadow.text = [NSString stringWithFormat:@"%d xp", points];
    
    [pointsLabel addChild: pointsShadow];
    [self addChild: pointsLabel];
    
    SKAction *animateToBar = nil;
    
    if (points != 0) {
    
        SKAction *moveUp = [SKAction moveByX:0 y:25 duration:0.5];
        SKAction *scalePointsUp = [SKAction scaleTo:4 duration:0.5];
        SKAction *scalePointsDown = [SKAction scaleTo:2 duration:0.5];
        SKAction *moveAndScaleUp = [SKAction group:@[moveUp, scalePointsUp]];
        SKAction *moveAndScaleDown = [SKAction group:@[moveUp, scalePointsDown]];
        
        animateToBar = [SKAction sequence:@[moveAndScaleUp, moveAndScaleDown, [SKAction waitForDuration:0.5]]];
    } else {
        pointsLabel.xScale = 2;
        pointsLabel.yScale = 2;
        animateToBar = [SKAction waitForDuration:2];
    }
    
    [pointsLabel runAction: animateToBar completion:^{
        [pointsLabel removeFromParent];
        [self reset];
    }];
}

@end
