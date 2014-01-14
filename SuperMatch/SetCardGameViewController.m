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

- (void)setUp
{
    self.cardAspectRatio = 0.75;
    self.numberOfCardsToDeal = 12;
    self.numberOfCardsToMatch = 3;
    self.matchedCardsAreToBeRemoved = YES;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc]init];
}

- (UIView *)cardViewInRectangle:(CGRect)rect {
    return [[SetCardView alloc]initWithFrame:rect];
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
            
//            [UIView transitionWithView:setCardView
//                              duration:0.75
//                               options:UIViewAnimationOptionTransitionCrossDissolve
//                            animations:^{
//                                setCardView.chosen = setCard.isChosen;
//                            }completion:NULL];
        }
    }
    
}

@end
