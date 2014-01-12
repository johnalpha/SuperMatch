//
//  SetCard.h
//  Matchismo
//
//  Created by john on 26/11/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

// 1, 2 or 3 for each property
@property (nonatomic) NSUInteger numberOfShapes;
@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger colour;
@property (nonatomic) NSUInteger shading;
@end
