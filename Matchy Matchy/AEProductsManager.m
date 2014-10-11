//
//  AEProductsManager.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-05-20.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEProductsManager.h"
#import "AEConfig.h"

@interface AEProductsManager() {
    NSArray *products;
    
}
@end
@implementation AEProductsManager


-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    //NSLog(@"Products response");
    products = response.products;
    //NSLog(@"Found %lu", (unsigned long)response.products.count);
}

-(void) request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to load products. %@", error.description);
}

-(void) loadProducts {
    NSSet *idSet = [NSSet setWithObject: REMOVE_ADS_PRODUCT_ID];
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: idSet];
    productsRequest.delegate = self;
    //NSLog(@"Attempting to load products");
    [productsRequest start];
}

-(SKProduct *) getProduct:(NSString *) productId {
    for(SKProduct *product in products) {
        if ([product.productIdentifier isEqualToString: productId]) {
            return product;
        }
    }
    
    return nil;
}
@end
