//
//  PlayingCard.m
//  Matchismo
//
//  Created by john on 01/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int score = 0;

    // gather the match set (self + otherCards) into a single array
    NSArray *matchSet = @[self];
    matchSet = [matchSet arrayByAddingObjectsFromArray:otherCards];

    // match all pairs in the matchSet array
    for (int i = 0; i < [matchSet count]; i++) {
        for (int j = i + 1; j < [matchSet count]; j++) {
            PlayingCard *firstCard = matchSet[i];
            PlayingCard *secondCard = matchSet[j];
            if (firstCard.rank == secondCard.rank) {
                score += 4;     // in a full PlayingCardDeck, there are 3 other cards of the same rank
            } else if (firstCard.suit == secondCard.suit) {
                score += 1;     // but 12 of the same suit
            }
        }
    }

    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)description {
    return [self contents];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) _suit = suit;
}

- (NSString *)suit {
    return (_suit ? _suit : @"?");
}

- (void)setRank:(NSInteger)rank {
    if (rank <= [PlayingCard maxRank]) _rank = rank;
}

+ (NSArray *)validSuits {
    return @[@"♥", @"♣", @"♦", @"♠"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

@end
