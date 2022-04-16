//
//  PlayingCardGame.m
//  FilpCardGame
//
//  Created by IraShinking on 2022/4/8.
//

#import "PlayingCardGame.h"
#import "PlayingCardDeck.h"


@interface PlayingCardGame()

@property(nonatomic) NSUInteger count;//of cards
@property(nonatomic) PlayingCardDeck *deck;//ofPlayingCardDeck
@property(nonatomic) NSMutableArray *cards;//of PlayingCard
@property(nonatomic,readwrite)NSInteger score;//let it be readwrite inside
@property(nonatomic) NSMutableArray *cardsMatched;//store the PlayingCard that matched
@property(nonatomic) NSString *matchingType;//store the matching type of the last two card

@end


@implementation PlayingCardGame

@synthesize matchTwoCard;
@synthesize cards;
@synthesize score;
@synthesize cardsMatched;
@synthesize matchingType;

static const int MIN_COUNT=2;
static const int MAX_COUNT=52;

-(instancetype)initWithCount:(NSUInteger)count
                     andDeck:(PlayingCardDeck *)deck
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
                if(theNextCard)
                {
                    [self.cards addObject:theNextCard];//放在桌面上
                }
                else
                {
                    break; //防止数组是空的，防止越界报错
                }
            }
            self.score=0;
            self.matchingType=@"";
            self.matchTwoCard=YES;
            self.count=count;
            self.deck=deck;
        }
    }
    
    return self;
}

-(instancetype)init
{
    return nil;//no arguments are pressed into it, so just return nil
}

-(void)reset
{
    [self.cards removeAllObjects];
    //发牌而且放到桌面上
    //发牌前检查牌堆 如果不够牌发了 给牌堆发消息，让它创建一些新的牌
    if([self.deck cardsCount]<self.count)
    {
        [self.deck resetDeck];
    }
    for(int i=0;i<self.count;i++)
    {
        Card *theNextCard=[self.deck drawRandomCard];//从牌堆里抽牌
        if(theNextCard)
        {
            [self.cards addObject:theNextCard];//放在桌面上
        }
        else
        {
            NSLog(@"the card is nil, you should create a new deck");
            break; //防止数组是空的，防止越界报错
        }
    }
    self.score=0;
    self.matchingType=@"";
    //self.matchTwoCard=YES; //dont pretend you know
}

-(NSMutableArray *)cards
{
    if(!cards)//lazy initalization
    {
        cards=[[NSMutableArray alloc]init];
    }
    
    return cards;
}

-(NSMutableArray *)cardsMatched
{
    if(!cardsMatched)
    {
        cardsMatched=[[NSMutableArray alloc]init];
    }
    return cardsMatched;
}


//now matching two or three card
-(void)matchingCardAtIndex:(NSUInteger)index
{
    PlayingCard *card=[self cardAtIndex:index];
    
    //NSLog(@"card %@ isChosen= %d",card.contents,card.isChosen?1:0);

    if(card.matched==NO)
    {
        if(card.chosen==YES)
        {
            card.chosen=NO; //if click the same card again,it would filp over
        }
        else
        {
            
            if(matchTwoCard==YES)
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
            }
            else if(matchTwoCard==NO)
            {
                //then match the card with others
                for(PlayingCard *nextCard in cards)
                {
                    if([nextCard isEqual:card]==NO&&nextCard.isChosen==YES&&nextCard.isMatched==NO)
                    {
                        
                        if([card.suit isEqualToString:nextCard.suit])
                        {
                            if([self.matchingType isEqualToString:@""]&&[self.cardsMatched count]==0) //no cards were matched before-first time match
                            {
                                self.matchingType=@"suitMatched";
                                [self.cardsMatched addObject:card];
                                [self.cardsMatched addObject:nextCard];
                                NSLog(@"Two cards matched in suit:%@",self.cardsMatched);
                            }
                            else if([self.matchingType isEqualToString:@"suitMatched"]&&[self.cardsMatched count]==2&&[self.cardsMatched indexOfObject:card]==NSNotFound)//three cards are matched in suit-second time match
                            {
                               
                                [self.cardsMatched addObject:card];
                                NSLog(@"all cards matched in suit:%@",self.cardsMatched);
                                [self allCardsMatched];
                                score+=2*3;
                            }
                            else //not the same type against the previous match
                            {
                                NSLog(@"card %@ is not match with all cards in suit %@",card,(self.cardsMatched)?self.cardsMatched:nextCard);
                                
                                [self cleanCardsMatched];
                                [self.cardsMatched addObject:card];
                                [self.cardsMatched addObject:nextCard];
                                matchingType=@"suitMatched";
                                
                            }
                        }
                        else if(card.rank==nextCard.rank)
                        {
                            if([self.matchingType isEqualToString:@""]&&[self.cardsMatched count]==0)// no cards where matched before-first time match
                            {
                                self.matchingType=@"rankMatched";
                                [self.cardsMatched addObject:card];
                                [self.cardsMatched addObject:nextCard];
                                NSLog(@"Two cards matched in rank:%@",self.cardsMatched);
                            }
                            else if([self.matchingType isEqualToString:@"rankMatched"]&&[self.cardsMatched count]==2&&[self.cardsMatched indexOfObject:card])//three cards are matched in rank-second time match
                            {
                                
                                [self.cardsMatched addObject:card];
                                NSLog(@"all cards matched in rank:%@",self.cardsMatched);
                                [self allCardsMatched];
                                score+=8*3;
                            }
                            else //not the same type against the previous match
                            {
                                NSLog(@"card %@ is not match with all cards in rank %@",card,(self.cardsMatched)?self.cardsMatched:nextCard);
                                [self cleanCardsMatched];
                                [self.cardsMatched addObject:card];
                                [self.cardsMatched addObject:nextCard];
                                matchingType=@"rankMatched";
                            }
                            
                        }
                        else
                        {
                            nextCard.chosen=NO;//如果不匹配，先点开的那张牌翻面
                            [self cleanCardsMatched];
                            
                        }
                        break;
                        
                    }
                }
            }
            
            //每一次选中另一张牌都要扣一分
            score-=1;
            card.chosen=YES;
            
        }
    }
    
}

//返回选中的牌
-(PlayingCard *)cardAtIndex:(NSUInteger)index
{
    return [cards count]>index? cards[index]:nil;
}

//mark the cards int cardsMatched as chosen and matched
-(void)allCardsMatched
{
    for(Card *card in self.cardsMatched)
    {
        card.matched=YES;
        card.chosen=YES;
    }
    [self.cardsMatched removeAllObjects];//dont forget this
    self.matchingType=@"";//reset the matching Type
}

//mark the cards in cardsMatched as not chosen and not matched and clean the cardsMatched
-(void)cleanCardsMatched
{
    for(Card *card in self.cardsMatched)
    {
        card.chosen=NO;
        if(card.matched==YES)
        {
            card.matched=NO;
        }
       // [self.cardsMatched removeObject:card]; DO NOT DO THIS
    }
    [self.cardsMatched removeAllObjects];
    self.matchingType=@"";//dont forget to reset it 
}

@end
