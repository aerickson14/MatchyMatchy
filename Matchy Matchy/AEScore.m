//
//  AEScore.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEScore.h"

@interface AEScore() {
    SKLabelNode *scoreLabel;
    NSInteger points;
}

@end

@implementation AEScore

-(id) init {
    if (self = [super init]) {
        points = 0;
        
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = [SKColor whiteColor];
        
        [self setScore: points];
        [self addChild: scoreLabel];
    }
    
    return self;
}

-(void) addPoints:(NSInteger) pointsToAdd {
    [self setScore: (points + pointsToAdd)];
}

-(void) setScore:(NSInteger) score {
    points = score;
    scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)points];
}

-(NSInteger) getScore {
    return points;
}

@end
