//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by john on 26/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCardGameViewController.h"

@interface SetCardGameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;
@property (strong, nonatomic) NSMutableArray *foundSets;
@property (nonatomic) NSUInteger nextSet;
@end

@implementation SetCardGameViewController

- (NSMutableArray *)foundSets
{
    if (!_foundSets) {
        _foundSets = [[NSMutableArray alloc]init];
    }
    return _foundSets;
}

- (void)setUp
{
    self.cardAspectRatio = 0.75;
    self.numberOfCardsToDeal = 12;
    self.numberOfCardsToMatch = 3;
    self.addCardsButton.enabled = YES;
}

#define DEFAULT_BUTTON_TITLE "Hint"

- (void)updateUI
{
    [super updateUI];
    if (self.game.matchScore) { // have a match with last card chosen?
        [self removeMatchedCardsAnimated];
    }
    [self.hintButton setTitle:@DEFAULT_BUTTON_TITLE forState:UIControlStateNormal];
}

- (void)removeMatchedCardsAnimated{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView *cardView in self.cardViews) {
                             Card *card = [self.game cardAtIndex:cardView.tag];
                             if (card.isMatched) {
                                 cardView.alpha = 0.0;
                             }
                         }
                     } completion:^(BOOL finished) {
                         if (finished) {
                             NSUInteger index = 0;
                             UIView *cardView = [self.cardViews firstObject];
                             while (cardView) {
                                 Card *card = [self.game cardAtIndex:cardView.tag];
                                 if (card.isMatched) {
                                     [self.cardViews removeObject:cardView];
                                     [cardView removeFromSuperview];
                                 } else {
                                     index++;
                                 }
                                 if (index < [self.cardViews count]) {
                                     cardView = self.cardViews[index];
                                 } else {
                                     break;
                                 }
                             }
                             [self rearrangeCardViews];
                         }
                     }];
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
        }
    }
    
}

- (IBAction)addThreeCards
{
    NSArray *newCards = [self.game addCards:3];
    if (newCards) {
        [self createCardViewsFromCards:newCards];
        [self rearrangeCardViews];
        [self updateUI];
    } else {
        self.addCardsButton.enabled = NO;
        NSLog(@"No more cards!");
    }
}

- (IBAction)hint:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@DEFAULT_BUTTON_TITLE]) {
        [self findSets];
        [sender setTitle:[NSString stringWithFormat:@"%d sets. Tap for more.", [self.foundSets count]]
                forState:UIControlStateNormal];
    } else {
        if ([self.foundSets count] > 0) {
            for (SetCardView *cardView in self.cardViews) {
                cardView.marked = NO;
            }
            self.nextSet = (self.nextSet % [self.foundSets count]);
            NSArray *cardNumbers = self.foundSets[self.nextSet];
            NSString *buttonTitle = [NSString stringWithFormat:@"%@, %@, %@. Tap for more.", cardNumbers[0], cardNumbers[1], cardNumbers[2]];
            [sender setTitle:buttonTitle forState:UIControlStateNormal];
            for (int i = 0 ; i < 3 ; i++) {
                int cardNumber = [cardNumbers[i] integerValue];
                SetCardView *cardView = self.cardViews[cardNumber];
                cardView.marked = YES;
            }
            self.nextSet++;
        }
    }
}

- (void)findSets
// searches through the Set cards on display to find (and remember) any Sets
{
    [self.foundSets removeAllObjects];
    self.nextSet = 0;
    NSUInteger matchScore = 0;
    NSUInteger numberOfCards = [self.cardViews count];
    // need to check all triples
    if (numberOfCards >= 3) {
        for (int i = 0 ; i < numberOfCards ; i++) {
            for (int j = (i + 1); j < numberOfCards ; j++) {
                for (int k = (j + 1) ; k < numberOfCards ; k++) {
                    UIView *cardView = self.cardViews[i];
                    Card *firstCard = [self.game cardAtIndex:cardView.tag];
                    cardView = self.cardViews[j];
                    Card *secondCard = [self.game cardAtIndex:cardView.tag];
                    cardView = self.cardViews[k];
                    Card *thirdCard = [self.game cardAtIndex:cardView.tag];
                    matchScore = [firstCard match:@[secondCard, thirdCard]];
                    if (matchScore) {
                        [self.foundSets addObject:@[@(i), @(j), @(k)]]; // foundSets is an array of arrays (of NSNumber triples)
                    }
                }
            }
        }
    }
}

@end
