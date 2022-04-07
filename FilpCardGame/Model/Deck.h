//
//  Deck.h
//  playCard
//
//  Created by IraShinking on 2022/3/27.
//

#import <Foundation/Foundation.h>
#import "Card.h"
NS_ASSUME_NONNULL_BEGIN

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(void)addCard:(Card *)card;

-(Card *)drawRandomCard;

@end

NS_ASSUME_NONNULL_END
