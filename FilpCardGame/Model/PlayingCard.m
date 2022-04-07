//
//  PlayingCard.m
//  playCard
//
//  Created by IraShinking on 2022/3/28.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit=_suit;//because we provide setter and getter using the "_suit" in it but not "suit"

-(NSString *)contents
{
    NSArray *rankString=[PlayingCard rankString];
    return [rankString[self.rank] stringByAppendingString:self.suit];
}

+(NSArray *)rankString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank
{
    return [[self rankString] count]-1;//why using self here? cause they are all class method,and the self pointer point to the PlayingCard class
}

+(NSArray *)vaildSuit
{
    //return @[@"hearts",@"clubs",@"diamonds",@"pip"];
    return @[@"♥️",@"♣️",@"♦️",@"♠️"];
}


-(void)setSuit:(NSString *)suit
{
    if([[PlayingCard vaildSuit] containsObject:suit])
    {
        _suit=suit;
    }
}

-(NSString *)suit
{
    //if _suit != nil
    //return _suit
    //else return @"?"
    return _suit? _suit:@"?";
}

-(void)setRank:(NSUInteger)rank
{
    if(rank<=[PlayingCard maxRank])
    {
        _rank=rank;
    }
}
@end

