//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by john on 03/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger matchScore;
@property (nonatomic, readwrite) Card *chosenCard;
@property (strong, nonatomic, readwrite) NSMutableArray *cards; // of Card
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (NSUInteger)numberOfCardsToMatch {
    return (_numberOfCardsToMatch >= 2 ? _numberOfCardsToMatch : 2);    // must be at least 2
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.deck = deck;
    }
    return self;
}

- (NSArray *)addCards:(NSUInteger)numberOfCardsToAdd
{
    BOOL success = YES;
    NSMutableArray *newCards = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < numberOfCardsToAdd ; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [newCards addObject:card];
        } else {
            success = NO;
            break;
        }
    }
    
    if (success) {
        [self.cards addObjectsFromArray:newCards];
    } else {
        newCards = nil;
    }
    
    return newCards;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count] ? self.cards[index] : nil);
}

- (NSUInteger)indexForCard:(Card *)card
// may return NSNotFound
{
    return [self.cards indexOfObject:card];
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    self.matchScore = 0;
    self.chosenCard = [self cardAtIndex:index];                         // get the chosen card
    if (!self.chosenCard.isMatched) {                                   // ignore it if it's already matched
        if (self.chosenCard.isChosen) {                                 // if it's already chosen
            self.chosenCard.chosen = NO;                                // just unchoose it
        } else {
            NSMutableArray *matchSet = [[NSMutableArray alloc]init];    // initialise matchSet with all other chosen and unmatched cards
            for (Card *card in self.cards) {
                if (card.isChosen && !card.isMatched) [matchSet addObject:card];
            }
            if ([matchSet count] == (self.numberOfCardsToMatch - 1)) {  // need the chosen card plus exactly (numberOfCardsToMatch - 1) other cards
                
                self.matchScore = [self.chosenCard match:matchSet];
                
//***********************
//**** ALWAYS MATCH *****
// self.matchScore = 4;
//***********************
                
                if (self.matchScore) {
                    // match
                    self.score += self.matchScore * MATCH_BONUS;
                    self.chosenCard.matched = YES;  // set cards as matched
                    for (Card *card in matchSet) card.matched = YES;
                } else {
                    // no match
                    self.score -= MISMATCH_PENALTY;
                    for (Card *card in matchSet) card.chosen = NO;      // unchoose all the other cards
                }
            }
            self.score -= COST_TO_CHOOSE;   // always a cost for choosing
            self.chosenCard.chosen = YES;
        }
    }
}

@end
