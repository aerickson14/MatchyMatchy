//
//  AEHistoryItem.m
//  Spinner
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEHistoryItem.h"
#import "AEConstants.h"

@interface AEHistoryItem() {
    bool isSet;
    NSString *itemName;
    SKSpriteNode *image;
}
@end

@implementation AEHistoryItem

-(id) init {
    if (self = [super init]) {
        isSet = NO;
        
        [self addBackground];
    }
    
    return self;
}

-(void) addBackground {
    
    SKShapeNode *background = [SKShapeNode node];
    
    CGMutablePathRef outline = CGPathCreateMutable();
    CGPathMoveToPoint(outline, nil, -30, -30);
    CGPathAddLineToPoint(outline, nil, 30, -30);
    CGPathAddLineToPoint(outline, nil, 30, 30);
    CGPathAddLineToPoint(outline, nil, -30, 30);
    CGPathAddLineToPoint(outline, nil, -30, -30);
    
    background.path = outline;
    background.fillColor = [AEConstants getGreyColor];
    background.strokeColor = [AEConstants getOrangeColor];
    background.zPosition = 1;
    
    [self addChild: background];
    
    CGPathRelease(outline);
    
}

-(void) setItem: (NSString *) initItemName {
    image = [SKSpriteNode spriteNodeWithImageNamed: initItemName];
    image.size = CGSizeMake(60,60);
    image.zPosition = 5;
    [self addChild: image];
    
    itemName = initItemName;
    isSet = true;
}

-(NSString *) getItemName {
    return itemName;
}

-(bool) isSet {
    return isSet;
}

-(void) reset {
    [image removeFromParent];
    isSet = NO;
    itemName = @"";
}

@end
