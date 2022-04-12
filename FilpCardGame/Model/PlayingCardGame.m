//
//  PlayingCardGame.m
//  FilpCardGame
//
//  Created by IraShinking on 2022/4/8.
//

#import "PlayingCardGame.h"


@interface PlayingCardGame()

@property(nonatomic) NSMutableArray *cards;//of PlayingCard
@property(nonatomic,readwrite)NSInteger score;//let it be readwrite inside

@end


@implementation PlayingCardGame

@synthesize cards;

@synthesize score;

static const int MIN_COUNT=2;
static const int MAX_COUNT=52;

-(instancetype)initWithCount:(NSUInteger)count
                     andDeck:(Deck *)deck
{
    self = [super init];
    if(self)
    {
        //至少要有两张牌互相匹配，不能多于一幅牌的数量
        if(count<MIN_COUNT||count>MAX_COUNT)
        {
            return nil;
        }
        else
        {
            //发牌而且放到桌面上
            for(int i=0;i<count;i++)
            {
                Card *theNextCard=[deck drawRandomCard];//从牌堆里抽牌
                [self.cards addObject:theNextCard];//放在桌面上
            }
            self.score=0;
        }
    }
    
    return self;
}

-(instancetype)init
{
    return nil;//no arguments are pressed into it, so just return nil
}

-(NSMutableArray *)cards
{
    if(!cards)//lazy initalization
    {
        cards=[[NSMutableArray alloc]init];
    }
    
    return cards;
}

//the main logic of the game
//match two card if they have same suit or rank,then score and return it
//the final chosen card in view will active this method,and pressed into it
-(void)matchingCardAtIndex:(NSUInteger)index
{
    PlayingCard *card=[self cardAtIndex:index];
    
    NSLog(@"card %@ isChosen= %d",card.contents,card.isChosen?1:0);

    if(card.matched==NO)
    {
        if(card.chosen==YES)
        {
            card.chosen=NO; //if click the same card again,it would filp over
            NSLog(@"Now card is not chosen");
        }
        else
        {
            //then match the card with others
            for(PlayingCard *nextCard in cards)
            {
                if([nextCard isEqual:card]==NO&&nextCard.isChosen==YES&&nextCard.isMatched==NO)
                {
                    
                    if([card.suit isEqualToString:nextCard.suit])
                    {
                        //score 1 times
                        score+=1;
                        card.matched=YES;
                        nextCard.matched=YES;
                        NSLog(@"card:%@ and  %@ is matched",[card contents],[nextCard contents]);
                    }
                    else if(card.rank==nextCard.rank)
                    {
                        //score 4 times
                        score+=4;
                        card.matched=YES;
                        nextCard.matched=YES;
                        NSLog(@"card:%@ and  %@ is matched",[card contents],[nextCard contents]);
                    }
                    else
                    {
                        nextCard.chosen=NO;//如果不匹配，先点开的那张牌翻面
                        NSLog(@"card:%@ and  %@ is NOT matched",[card contents],[nextCard contents]);
                    }
                    break;
                    
                }
            }
            //每一次选中另一张牌都要扣一分
            score-=1;
            card.chosen=YES;
            NSLog(@"Now card is chosen");
            
        }
    }
    
}

//返回选中的牌
-(PlayingCard *)cardAtIndex:(NSUInteger)index
{
    return [cards count]>index? cards[index]:nil;
}
@end
