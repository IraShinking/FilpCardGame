//
//  PlayingCard.h
//  playCard
//
//  Created by IraShinking on 2022/3/28.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard : Card

@property(strong,nonatomic)NSString *suit;
@property(nonatomic)NSUInteger rank;

+(NSArray *)vaildSuit;
+(NSUInteger)maxRank;
@end

NS_ASSUME_NONNULL_END
