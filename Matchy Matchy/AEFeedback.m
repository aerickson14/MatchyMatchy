//
//  AEFeedback.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-04-24.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEFeedback.h"
#import "AEViewController.h"
#import "AEConstants.h"
#import "AEScene.h"
#import "AETextBlock.h"

@interface AEFeedback() {
    SKShapeNode *bgSprite;
    NSString *text;
}
@end

@implementation AEFeedback

+(instancetype) initWithText:(NSString *) initText {
    AEFeedback *node = [AEFeedback node];
    node.anchorPoint = CGPointMake(0.5,0.5);
    [node setUserInteractionEnabled: YES];
    [node setText: initText];
    
    return node;
}

-(void) setText:(NSString *) initText {
    text = initText;
}

-(void) animateOpen {
    
    self.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    self.xScale = 0;
    self.yScale = 0;
    
    bgSprite = [SKShapeNode node];
    CGFloat bgWidth = 280;
    CGFloat bgHeight = 150;
    CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake((-0.5*bgWidth), (-0.5*bgHeight), bgWidth, bgHeight), 10, 10, nil);
    [bgSprite setPath: path];
    CGPathRelease(path);
    bgSprite.strokeColor = bgSprite.fillColor = [AEConstants getOrangeColor];
    
    [self addChild: bgSprite];
    
    AETextBlock *textBlock = [AETextBlock node];
    [self addChild: textBlock];
    [textBlock initWithText: text size: CGSizeMake(bgWidth, bgHeight)];
    
    AEViewController *viewController = (AEViewController *) self.scene.view.window.rootViewController;
    [viewController enableUIElements:NO];
    
    SKAction *openAction = [SKAction scaleTo:1.0 duration:0.5];
    
    [self runAction: openAction completion:^{
        [self runAction: [SKAction waitForDuration:5] completion:^{
            [self dismiss];
        }];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Touches began in feedback node");
    [self dismiss];
}

-(void) dismiss {
    
    SKAction *shrinkAction = [SKAction scaleTo:0.0 duration:0.5];
    
    [self runAction: shrinkAction completion:^{
        AEViewController *viewController = (AEViewController *) self.scene.view.window.rootViewController;
        [viewController enableUIElements:YES];
        [self removeFromParent];
    }];
}

@end
