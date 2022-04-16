//
//  Deck.m
//  playCard
//
//  Created by IraShinking on 2022/3/27.
//

#import "Deck.h"

@interface Deck()

@property(strong,nonatomic) NSMutableArray *cards;//of Card

@end

@implementation Deck

@synthesize cards;

-(NSMutableArray *)cards
{
    if(!cards)//check it in getter
    {
        cards=[[NSMutableArray alloc]init];
    }
    return cards;
}
-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if(atTop)
    {
        [self.cards insertObject:card atIndex:0];
    }
    else
    {
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card
{
    if([self.cards indexOfObject:card]==NSNotFound)//如果不允许牌堆里有重复的牌
    {
        [self addCard:card atTop:NO];
    }
    
}

-(Card *)drawRandomCard
{
    Card *randomCard=nil;
    
    if([self.cards count]!=0)
    {
        
        unsigned index= arc4random()%[self.cards count];
        randomCard=self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

-(NSUInteger)cardsCount
{
    return [self.cards count];
}
@end
