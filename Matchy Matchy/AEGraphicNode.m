//
//  AEGraphicNode.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-04-29.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEGraphicNode.h"

@implementation AEGraphicNode

-(void) setImageNamed:(NSString *) imageName position:(int) pos of:(int) total {
    
    SKCropNode *cropNode = [SKCropNode node];
    cropNode.name = @"cropNode";
    CGPointMake( CGRectGetMidX (self.frame), CGRectGetMidY (self.frame));
    
    SKSpriteNode *imageNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    imageNode.name = @"imageNode";
    imageNode.position = CGPointMake(0, 0);
    imageNode.anchorPoint = CGPointMake(0.5, 0.5);
    [cropNode addChild: imageNode];
    
    CGFloat imageHeight = imageNode.frame.size.height;
    CGFloat maskYVal = -imageHeight/2 + imageHeight/(2*total) + pos*(imageHeight/total);
    CGSize maskSize = CGSizeMake(imageNode.frame.size.width, imageHeight/total);
    SKSpriteNode *maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size: maskSize];
    maskNode.position = CGPointMake(0, maskYVal);
    maskNode.anchorPoint = CGPointMake(0.5, 0.5);
    cropNode.maskNode = maskNode;
    
    [self addChild: cropNode];
}
@end
