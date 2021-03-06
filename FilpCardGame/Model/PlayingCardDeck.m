//
//  PlayingCardDeck.m
//  playCard
//
//  Created by IraShinking on 2022/3/28.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

-(instancetype)init
{
    self=[super init];
    
    if(self)
    {
        //生成一整幅牌并且加入到牌堆里面
        for(NSString *suit in [PlayingCard vaildSuit])
        {
            for(NSUInteger rank=1; rank<=[PlayingCard maxRank];rank++)
            {
                PlayingCard *card=[[PlayingCard alloc]init];
                card.rank=rank;
                card.suit=suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

-(void)resetDeck
{
    //生成一整幅牌并且加入到牌堆里面
    for(NSString *suit in [PlayingCard vaildSuit])
    {
        for(NSUInteger rank=1; rank<=[PlayingCard maxRank];rank++)
        {
            PlayingCard *card=[[PlayingCard alloc]init];
            card.rank=rank;
            card.suit=suit;
            [self addCard:card];
        }
    }
}

@end
