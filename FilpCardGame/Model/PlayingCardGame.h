//
//  PlayingCardGame.h
//  FilpCardGame
//
//  Created by IraShinking on 2022/4/8.
//

#import <Foundation/Foundation.h>
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGame : NSObject

@property(nonatomic) BOOL matchTwoCard;//control the game is matching two card or three card
@property(nonatomic,readonly) NSInteger score;//can only be read by public

-(instancetype)initWithCount:(NSUInteger)count
                     andDeck:(Deck *)deck;
//换行让分号对齐 是好的书写习惯

-(void)matchingCardAtIndex:(NSUInteger)index;
-(PlayingCard *)cardAtIndex:(NSUInteger)index;
-(void)reset;//reset the game
@end

NS_ASSUME_NONNULL_END
