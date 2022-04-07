//
//  ViewController.m
//  FilpCardGame
//
//  Created by IraShinking on 2022/3/28.
//

#import "ViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *FilpTimes;
@property(nonatomic) NSUInteger filpCounts;
@property(nonatomic)PlayingCardDeck *deck;
@property(nonatomic)Card *card;

@end

@implementation ViewController

-(void)setFilpCounts:(NSUInteger)filpCounts
{
    _filpCounts=filpCounts;
    
    [self.FilpTimes setText:[NSString stringWithFormat:@"FilpTimes: %lu",self.filpCounts]];
    
}


- (IBAction)FilpCardBtn:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"The Back"])
    {
       if(_deck==nil)
       {
           _deck=[[PlayingCardDeck alloc]init];
       }
        
        _card=[_deck drawRandomCard];
        [sender setTitle:_card.contents forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"The Back" forState:UIControlStateNormal];
        
    }
    self.filpCounts++;
    
}
@end
