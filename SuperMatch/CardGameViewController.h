//
//  CardGameViewController.h
//  SuperMatch
//
//  Created by john on 05/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//
//  ABSTRACT CLASS.
//  Sub-classes must implement methods as indicated below.

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic, readwrite) CardMatchingGame *game;
@property (strong, nonatomic, readwrite) NSMutableArray *cardViews; // of UIViews

//@property (strong, nonatomic, readonly) CardMatchingGame *game;
//@property (strong, nonatomic, readonly) NSMutableArray *cardViews;  // of UIViews

//----------------- abstract methods ------------- protected - for sub-classes ------------------------
- (Deck *)createDeck;
- (NSUInteger)numberOfCardsToDeal;
- (NSUInteger)numberOfCardsToMatch;
- (CGFloat)cardAspectRatio;
- (UIView *)cardViewInRectangle:(CGRect)rect;
- (void)updateCardViews;
- (void)setCardView:(UIView *)cardView usingCard:(Card *)card;
//-----------------------------------------------------------------------------------------------------

@end
