//
//  AEHistoryItem.h
//  Spinner
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AEHistoryItem : SKSpriteNode

-(NSString *) getItemName;

-(void) setItem: (NSString *) itemName;

-(bool) isSet;

-(void) reset;

@end
