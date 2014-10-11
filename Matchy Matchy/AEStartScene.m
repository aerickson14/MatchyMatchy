//
//  AEStartScene.m
//  Spinner
//
//  Created by Andrew Erickson on 3/1/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEStartScene.h"
#import "AEGameScene.h"
#import "AEConstants.h"
#import "AEViewController.h"

@implementation AEStartScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [AEConstants getTealColor];
        self.scaleMode = SKSceneScaleModeAspectFill;
        
        [self addChild: [self createLogo]];
        
        [self addChild: [self createPreviewScroller]];
    }
    
    return self;
}

- (SKSpriteNode *) createLogo {
    
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
    logo.anchorPoint = CGPointMake(0.5, 0.5);
    logo.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 150);
    
    return logo;
}

- (SKSpriteNode *) createPreviewScroller {
    
    SKSpriteNode *previewScroller = [SKSpriteNode node];
    previewScroller.anchorPoint = CGPointMake(0.5, 0.5);
    
    [previewScroller addChild: [self createOrangeBar]];
    
    
    SKTextureAtlas *graphicAtlas = [SKTextureAtlas atlasNamed:@"pieces"];
    
    for(int i=0; i<4; i++) {
        int g=0;
        NSArray *graphicNames = [AEConstants getGraphicNames];
        CGFloat gTotal = [graphicNames count];
        
        for(NSString *graphicName in graphicNames) {
            g++;
            
            SKTexture *texture = [graphicAtlas textureNamed: [NSString stringWithFormat: @"%@_1", graphicName]];
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
            sprite.anchorPoint = CGPointMake(0.5, 0.5);
            sprite.xScale = 0.5;
            sprite.yScale = 0.5;
            
            int x = (((i*gTotal) + (g-0.75)) * sprite.size.width) - self.frame.size.width/2;
            sprite.position = CGPointMake(x, 14);
            
            CGFloat padding = 130;
            CGFloat startPoint = (self.frame.size.width/2) + padding;
            CGFloat endPoint = -startPoint;
            CGFloat speed = (self.scene.frame.size.width + (padding*2)) / 8;
            CGFloat time1 = (x-endPoint) / speed;
            SKAction *firstScrollAction = [SKAction moveToX:endPoint duration:time1];
            SKAction *moveAction = [SKAction moveToX:startPoint duration:0];
            SKAction *fullscrollAction = [SKAction moveToX:endPoint duration:8.0];
            SKAction *repeatSequenece = [SKAction sequence:@[moveAction, fullscrollAction]];
            SKAction *scrollForeverAction = [SKAction repeatActionForever: repeatSequenece];
            SKAction *scrollSequence = [SKAction sequence:@[firstScrollAction, scrollForeverAction]];
            
            [sprite runAction: scrollSequence];
            
            [previewScroller addChild: sprite];
        }
    }
    
    previewScroller.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 250);
    
    return previewScroller;
}

- (void) didMoveToView:(SKView *)view {
}

- (SKShapeNode *) createOrangeBar {
    
    SKShapeNode *bar = [SKShapeNode node];
    
    CGMutablePathRef outline = CGPathCreateMutable();
    CGPathMoveToPoint(outline, nil, -self.size.width/2, -3);
    CGPathAddLineToPoint(outline, nil, self.size.width/2, -3);
    CGPathAddLineToPoint(outline, nil, self.size.width/2, 0);
    CGPathAddLineToPoint(outline, nil, -self.size.width/2, 0);
    CGPathAddLineToPoint(outline, nil, -self.size.width/2, -3);
    
    bar.path = outline;
    bar.fillColor = [AEConstants getOrangeColor];
    bar.strokeColor = [AEConstants getOrangeColor];
    bar.zPosition = 50;
    
    CGPathRelease(outline);
    
    return bar;
}

@end
