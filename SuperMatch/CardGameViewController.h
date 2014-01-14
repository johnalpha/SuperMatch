//
//  CardGameViewController.h
//  SuperMatch
//
//  Created by john on 05/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//
//  ABSTRACT CLASS.
//  Sub-classes must set properties and implement methods as indicated below.

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController

//--------------------- properties which must be set by concrete subclasses --------------------------
@property (nonatomic) BOOL matchedCardsAreToBeRemoved;
@property (nonatomic) NSUInteger numberOfCardsToDeal;
@property (nonatomic) NSUInteger numberOfCardsToMatch;
@property (nonatomic) CGFloat cardAspectRatio;

//----------------- abstract methods ------------------- protected - for sub-classes -----------------
- (void)setUp;
- (Deck *)createDeck;
- (UIView *)cardViewInRectangle:(CGRect)rect;
- (void)setCardView:(UIView *)cardView usingCard:(Card *)card;
//-----------------------------------------------------------------------------------------------------

@end
