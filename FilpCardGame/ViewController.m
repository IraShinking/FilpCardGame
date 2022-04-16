//
//  ViewController.m
//  FilpCardGame
//
//  Created by IraShinking on 2022/3/28.
//

#import "ViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardGame.h"

@interface ViewController ()


@property(nonatomic)PlayingCardDeck *deck;
@property(nonatomic)PlayingCardGame *game;//cardGame

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;


@end

@implementation ViewController

@synthesize deck;
@synthesize game;
@synthesize cardButtons;
@synthesize scoreLabel;



-(PlayingCardDeck *)deck
{
    if(!deck)
    {
        deck=[[PlayingCardDeck alloc] init];
    }
    return deck;
}

-(PlayingCardGame *)game
{
    if(!game)
    {
        //生成game 完成发牌
        game=[[PlayingCardGame alloc] initWithCount:[cardButtons count] andDeck:self.deck];
    }

    return game;
}

-(IBAction)touchCardButtons:(UIButton *)sender
{
    NSUInteger cardIndex=[self.cardButtons indexOfObject:sender];
    [self.game matchingCardAtIndex:cardIndex];
    [self updateUI];
}

-(void)updateUI
{
    for(UIButton *button in self.cardButtons)
    {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:button];
        Card *card=[game cardAtIndex:cardIndex];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        
        button.enabled=!card.isMatched;//if the card is matched, disable the button
    }
    
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %ld",self.game.score]];
}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"The Back" ;
}

-(IBAction)switchGameType:(UISegmentedControl *)sender
{
    //reset game to change;
    NSInteger index=sender.selectedSegmentIndex;
    if(index==0)
    {
        [self.game reset];
        [self updateUI];
        NSLog(@"Matching two card");
        [self.game setMatchTwoCard:YES];//remember to use getter, for lazy initalization
        
    }
    else if(index==1)
    {
        [self.game reset];
        [self updateUI];
        NSLog(@"Matching three card");
        [self.game setMatchTwoCard:NO];
        
        
    }
}

- (IBAction)resetButton:(UIButton *)sender {
    
    NSLog(@"reset button is pressed");
    [self.game reset];
    [self updateUI];
}


@end
