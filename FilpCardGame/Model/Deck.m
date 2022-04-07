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

-(NSMutableArray *)cards
{
    if(!_cards)//check it in getter
    {
        _cards=[[NSMutableArray alloc]init];
    }
    return _cards;
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
    [self addCard:card atTop:NO];
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

@end
