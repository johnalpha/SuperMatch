//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by john on 21/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCardGameViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc]init];
}

- (NSUInteger)numberOfCardsToDeal {
    return 22;
}

- (NSUInteger)numberOfCardsToMatch {
    return  2;
}

- (CGFloat)cardAspectRatio {
    return 0.75;
}

- (UIView *)cardViewInRectangle:(CGRect)rect {
    return [[PlayingCardView alloc]initWithFrame:rect];
}

- (void)updateCardViews {
    for (UIView *cardView in self.cardViews) {
        [self setCardView:cardView
                usingCard:[self.game cardAtIndex:cardView.tag]];
    }
}

- (void)setCardView:(UIView *)cardView usingCard:(Card *)card {
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        if ([cardView isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.alpha = (card.isMatched ? 0.75 : 1.0);
            if (playingCardView.isFaceUp != card.isChosen) {    // chosen cards must be face up
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    playingCardView.faceUp = card.isChosen;
                                }completion:NULL];
            }
        }
    }
    
}

@end
