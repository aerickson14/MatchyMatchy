//
//  AEFeedbackGenerator.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEFeedbackGenerator : NSObject

+(NSString *) getFeedbackForPoints: (int) points matching: (int) numMatching correct: (int) numCorrect prev: (int) prevLevel current: (int) currentLevel;

@end
