//
//  AEPaymentManager.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-05-20.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;

@interface AEPaymentManager : NSObject <SKPaymentTransactionObserver>

-(void) purchaseProduct:(SKProduct *)product;

@end
