//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by john on 26/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCardGameViewController.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck {
    return [[SetCardDeck alloc]init];
}

- (NSUInteger)numberOfCardsToDeal {
    return 12;
}

- (NSUInteger)numberOfCardsToMatch {
    return  3;
}

- (CGFloat)cardAspectRatio {
    return 0.75;
}

- (UIView *)cardViewInRectangle:(CGRect)rect {
    return [[SetCardView alloc]initWithFrame:rect];
}

- (void)updateCardViews
// matched cards will be removed.
{
    BOOL cardsHaveBeenRemoved = NO;
    NSUInteger index = 0;
    UIView *cardView = [self.cardViews firstObject];
    
    while (cardView) {
        Card *card = [self.game cardAtIndex:cardView.tag];
        if (card.isMatched) {
            [self.cardViews removeObject:cardView];
            [cardView removeFromSuperview];
            cardsHaveBeenRemoved = YES;
        } else {
            [self setCardView:cardView usingCard:card];
            index++;
        }
        if (index < [self.cardViews count]) {
            cardView = self.cardViews[index];
        } else {
            break;
        }
    }
}

- (void)setCardView:(UIView *)cardView usingCard:(Card *)card {
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        if ([cardView isKindOfClass:[SetCardView class]]) {
            SetCardView *setCardView = (SetCardView *)cardView;
            setCardView.numberOfShapes = setCard.numberOfShapes;
            setCardView.shape = setCard.shape;
            setCardView.colour = setCard.colour;
            setCardView.shading = setCard.shading;
            setCardView.chosen = setCard.isChosen;
        }
    }
    
}

@end
