//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by john on 03/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

@interface CardMatchingGame : NSObject

// designated initialiser
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)indexForCard:(Card *)card;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (NSArray *)addCards:(NSUInteger)numberOfCardsToAdd;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger matchScore;
@property (strong, nonatomic, readonly) NSMutableArray *cards;  // of Card

@property (nonatomic) NSUInteger numberOfCardsToMatch;

@end
