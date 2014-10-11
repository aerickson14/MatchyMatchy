//
//  AEMyScene.h
//  Spinner
//

//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEScene.h"

@interface AEGameScene : AEScene

-(id) initWithSize:(CGSize)size;

-(void) addItemHistory: (NSString *) itemName;

-(void) setFeedback: (NSString *) feedbackText;

-(void) animateItemToHistory:(NSString *) itemName;

-(void) checkHistory;

@end
