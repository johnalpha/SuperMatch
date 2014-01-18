//
//  SetCard.m
//  Matchismo
//
//  Created by john on 26/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    // gather the match set (self + otherCards) into a single array
    NSArray *matchSet = @[self];
    matchSet = [matchSet arrayByAddingObjectsFromArray:otherCards];
    
    // a Set must be 3 cards
    if ([matchSet count] == 3) {
        SetCard *firstCard = matchSet[0];
        SetCard *secondCard = matchSet[1];
        SetCard *thirdCard = matchSet[2];
        
        //each card has 4 properties (numberOfShapes, shape, colour, shading) each with a value of 1, 2 or 3.
        //to make a Set, each property must be "all the same" or "all different" over the 3 cards
        NSUInteger x = firstCard.numberOfShapes;
        NSUInteger y = secondCard.numberOfShapes;
        NSUInteger z = thirdCard.numberOfShapes;
        if ((x == y && y == z) || (x != y && y != z && x != z)) {
            x = firstCard.shape;
            y = secondCard.shape;
            z = thirdCard.shape;
            if ((x == y && y == z) || (x != y && y != z && x != z)) {
                x = firstCard.colour;
                y = secondCard.colour;
                z = thirdCard.colour;
                if ((x == y && y == z) || (x != y && y != z && x != z)) {
                    x = firstCard.shading;
                    y = secondCard.shading;
                    z = thirdCard.shading;
                    if ((x == y && y == z) || (x != y && y != z && x != z)) {
                        score = 4;  // have a Set
                    }
                }
            }

        }
    }
// always a set **********************************************
//score = 4;
// ***********************************************************

    return score;
}

@end
