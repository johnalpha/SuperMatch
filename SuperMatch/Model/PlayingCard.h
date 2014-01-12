//
//  PlayingCard.h
//  Matchismo
//
//  Created by john on 01/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
