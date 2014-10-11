//
//  AEProductsManager.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-05-20.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

@import StoreKit;

@interface AEProductsManager : NSObject <SKProductsRequestDelegate>

-(void) loadProducts;

-(SKProduct *) getProduct:(NSString *) productId;

@end
