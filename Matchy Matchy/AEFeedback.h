//
//  AEFeedback.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-04-24.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AEFeedback : SKSpriteNode

+(instancetype) initWithText:(NSString *) text;

-(void) animateOpen;

@end
