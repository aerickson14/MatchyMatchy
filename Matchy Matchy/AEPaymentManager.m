//
//  AEPaymentManager.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-05-20.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEPaymentManager.h"
#import "AEAppDelegate.h"
#import "AEDefaultsManager.h"
#import "AEConfig.h"

@interface AEPaymentManager() {
    AEDefaultsManager *defaultsManager;
}
@end

@implementation AEPaymentManager

-(id) init {
    if (self = [super init]) {
        defaultsManager = [[AEDefaultsManager alloc] init];
    }
    
    return self;
}

-(void) purchaseProduct:(SKProduct *)product {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];

    //NSLog(@"Purchasing product: %@", product.productIdentifier);
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                //NSLog(@"Purchasing prompted");
                break;
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored:
                [self unlockAdDisabling];
                //NSLog(@"Transaction completed");
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //NSLog(@"Failed transaction: %@", transaction.error.description);
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            default:
                //NSLog(@"Unexpected transaction state. Transaction not processed.");
                break;
        }
    }
}

-(void) unlockAdDisabling {
    AEAppDelegate *appDelegate = (AEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate removeAds];
    
    [defaultsManager saveValueForKey: REMOVE_ADS_PRODUCT_ID withValue:@"YES"];
}

@end
