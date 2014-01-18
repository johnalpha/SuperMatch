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

@property (strong, nonatomic, readonly) CardMatchingGame *game;
@property (strong, nonatomic, readonly) NSMutableArray *cardViews; // of UIViews

- (void)updateUI;   // if overridden, subclass method must call [super updateUI] before any other code

- (void)createCardViewsFromCards:(NSArray *)cards;
- (void)rearrangeCardViews;

//--------------------- properties which must be set by concrete subclasses --------------------------
@property (nonatomic) NSUInteger numberOfCardsToDeal;
@property (nonatomic) NSUInteger numberOfCardsToMatch;
@property (nonatomic) CGFloat cardAspectRatio;

//----------------- abstract methods which must be implemented by concrete subclasses ----------------
- (void)setUp;
- (Deck *)createDeck;
- (UIView *)cardViewInRectangle:(CGRect)rect;
- (void)setCardView:(UIView *)cardView usingCard:(Card *)card;
//-----------------------------------------------------------------------------------------------------

@end
