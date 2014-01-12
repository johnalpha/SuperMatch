//
//  SetCardDeck.m
//  Matchismo
//
//  Created by john on 26/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (instancetype)init {
    self = [super init];
    if (self) {
        for (int numberOfShapes = 1; numberOfShapes < 4; numberOfShapes++) {
            for (int shape = 1 ; shape < 4 ; shape++) {
                for (int colour = 1 ; colour < 4 ; colour++) {
                    for (int shading = 1 ; shading < 4 ; shading++) {
                        SetCard *card = [[SetCard alloc]init];
                        card.numberOfShapes = numberOfShapes;
                        card.shape = shape;
                        card.colour = colour;
                        card.shading = shading;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
