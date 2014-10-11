//
//  AETextBlock.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-04-27.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AETextBlock.h"

@implementation AETextBlock

-(void) initWithText:(NSString *) text size:(CGSize) size {
    
    int charsPerLine = 26;
    int fontSize = 18;
    NSMutableArray *lines = [self splitIntoLines: text lineWidth: charsPerLine];
    
    int curYPos = CGRectGetMidY(self.frame);
    curYPos += (fontSize*[lines count])/2;
    for(int i=0; i<[lines count]; i++) {
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label.text = lines[i];
        label.fontColor = [SKColor whiteColor];
        label.fontSize = fontSize;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.position = CGPointMake(CGRectGetMidX(self.frame), curYPos);
        
        [self addChild:label];
        
        curYPos -= fontSize;
    }
}

-(NSMutableArray *) splitIntoLines:(NSString *) text lineWidth: (int) charsPerLine {
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSString *line = @"";
    
    for(NSString * word in words) {
        if ([word length] + [line length] <= charsPerLine) {
            line = [line stringByAppendingString: @" "];
            line = [line stringByAppendingString: word];
        } else {
            [lines addObject: line];
            line = word;
        }
    }
    
    if (![line isEqualToString:@""]) [lines addObject: line];
    
    return lines;
}

@end
