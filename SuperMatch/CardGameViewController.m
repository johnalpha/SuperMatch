//
//  CardGameViewController.m
//  SuperMatch
//
//  Created by john on 05/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *table;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
//@property (strong, nonatomic, readwrite) CardMatchingGame *game;
//@property (strong, nonatomic, readwrite) NSMutableArray *cardViews; // of UIViews
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSMutableArray *attachmentBehaviours; // of UIAttachmentBehaviours
@property (nonatomic) BOOL cardsArePinchedTogether;
@end

@implementation CardGameViewController

#pragma mark - abstract methods

- (Deck *)createDeck
{
    return nil;
}

- (NSUInteger)numberOfCardsToDeal
{
    return 0;
}

- (NSUInteger)numberOfCardsToMatch
{
    return  0;
}

- (CGFloat)cardAspectRatio
{
    return 0.0;
}

- (UIView *)cardViewInRectangle:(CGRect)rect
{
    return nil;
}

- (void)updateCardViews
{
}

- (void)setCardView:(UIView *)cardView usingCard:(Card *)card
{
}

#pragma mark - properties

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numberOfCardsToDeal]
                                                  usingDeck:[self createDeck]];
        _game.numberOfCardsToMatch = [self numberOfCardsToMatch];
    }
    return _game;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc]init];
    return _cardViews;
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc]init];
    }
    return _grid;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.table];
    }
    return _animator;
}

- (NSMutableArray *)attachmentBehaviours
{
    if (!_attachmentBehaviours) {
        _attachmentBehaviours = [[NSMutableArray alloc]init];
    }
    return _attachmentBehaviours;
}

#pragma mark - view controller lifecycle

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    [self createCardViewsFromCards:self.game.cards];
    self.addCardsButton.enabled = YES;
    self.cardsArePinchedTogether = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    if (!self.cardsArePinchedTogether) [self redealCardViews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation");
    NSLog(@"table: width = %g, height = %g", self.table.bounds.size.width, self.table.bounds.size.height);
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (self.cardsArePinchedTogether) {
        CGPoint centreOfTable = {(0.5 * self.table.bounds.size.width), (0.5 * self.table.bounds.size.height)};
        for (UIAttachmentBehavior *attachmentBehaviour in self.attachmentBehaviours) {
            attachmentBehaviour.anchorPoint = centreOfTable;
        }
    } else {
        [self rearrangeCardViews];
    }
}

//- (void)viewDidLayoutSubviews
//{
//    NSLog(@"viewDidLayoutSubviews");
//    NSLog(@"width = %g, height = %g", self.table.bounds.size.width, self.table.bounds.size.height);
//    [super viewDidLayoutSubviews];
//    NSLog(@"width = %g, height = %g", self.table.bounds.size.width, self.table.bounds.size.height);
//
//    if (self.cardsArePinchedTogether) {
//        CGPoint centreOfTable = {(0.5 * self.table.bounds.size.width), (0.5 * self.table.bounds.size.height)};
//        for (UIAttachmentBehavior *attachmentBehaviour in self.attachmentBehaviours) {
//            attachmentBehaviour.anchorPoint = centreOfTable;
//        }
//    } else {
//        [self rearrangeCardViews];
//    }
//}

#pragma mark -

- (void)createCardViewsFromCards:(NSArray *)cards
// cardViews will be zero size and centred at the lower left-hand corner of the table.
{
    for (Card *card in cards) {
        [self createCardViewFromCard:card];
    }
}

- (UIView *)createCardViewFromCard:(Card *)card
// cardView will be zero size and centred at the lower left-hand corner of the table.
{
    CGPoint location = CGPointMake(0.0, self.table.bounds.size.height); // lower left-hand corner of table
    UIView *cardView = [self cardViewInRectangle:CGRectZero];   // CGRectZero OK?
    if (cardView) {
        [self setCardView:cardView usingCard:card];
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(handleTap:)]];
        cardView.center = location;
        cardView.tag = [self.game indexForCard:card];
        
        [self.cardViews addObject:cardView];
        [self.table addSubview:cardView];
    }
    return cardView;
    
}

#define MINIMUM_COLUMN_COUNT 5

- (BOOL)setGrid
// tries to set a grid to display the existing set of card views.
// returns success or failure.
{
    self.grid.size = self.table.bounds.size;
    self.grid.cellAspectRatio = [self cardAspectRatio];
    self.grid.minimumNumberOfCells = [self.cardViews count];
    self.grid.maxCellWidth = self.table.bounds.size.width / MINIMUM_COLUMN_COUNT;
    return (self.grid.inputsAreValid ? YES : NO);
}

- (void)redealCardViews
// creates new grid and deals (sequentially) existing cardViews onto it.
{
    if ([self setGrid]) {
        [self dealCardViews];
//        self.addCardsButton.enabled = YES;
//        self.cardsArePinchedTogether = NO;
    } else {
        NSLog(@"redealCardViews: grid is invalid");
    }
}

-(void)dealCardViews
// deals onto existing grid, animated.
{
    CGFloat delay = 0.0;
    CGFloat delayIncrement = 0.4 / [self.cardViews count];  // more cards -> faster animation
    NSUInteger index = 0;
    while (index < [self.cardViews count]) {
        NSUInteger row = index / self.grid.columnCount;
        NSUInteger column = index % self.grid.columnCount;
        UIView *cardView = self.cardViews[index];
        [UIView animateWithDuration:0.5
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cardView.frame = [self.grid frameOfCellAtRow:row inColumn:column];
                         } completion:^(BOOL finished) {
                             nil;
                         }];
        delay += delayIncrement;
        index++;
    }
}

- (void)rearrangeCardViews
// creates new grid and arranges (simultaneously) existing cardViews onto it.
{
    if ([self setGrid]) {
        [self arrangeCardViews];
//        self.addCardsButton.enabled = YES;
//        self.cardsArePinchedTogether = NO;
    } else {
        NSLog(@"rearrangeCardViews: grid is invalid");
    }
}

- (void)arrangeCardViews
// arranges onto existing grid, animated.
{
    [UIView transitionWithView:self.table
                      duration:0.5
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                        NSUInteger index = 0;
                        while (index < [self.cardViews count]) {
                            UIView *cardView = self.cardViews[index];
                            NSUInteger row = index / self.grid.columnCount;
                            NSUInteger column = index % self.grid.columnCount;
                            cardView.frame = [self.grid frameOfCellAtRow:row inColumn:column];
                            index++;
                        }
                    } completion:^(BOOL finished) {
                        nil;
                    }];
    
    
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         NSUInteger index = 0;
//                         while (index < [self.cardViews count]) {
//                             UIView *cardView = self.cardViews[index];
//                             NSUInteger row = index / self.grid.columnCount;
//                             NSUInteger column = index % self.grid.columnCount;
//                             cardView.frame = [self.grid frameOfCellAtRow:row inColumn:column];
//                             index++;
//                         }
//                     }];
}

- (void)updateUI
{
    [self updateCardViews];
    [self rearrangeCardViews];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"handleTap");
    if (self.cardsArePinchedTogether) {
        [self.attachmentBehaviours removeAllObjects];
        [self.animator removeAllBehaviors];
        [self rearrangeCardViews];
        self.addCardsButton.enabled = YES;
        self.cardsArePinchedTogether = NO;
    } else {
        [self.game chooseCardAtIndex:sender.view.tag];
    }
    [self updateUI];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender
{
    CGPoint pinchLocation = [sender locationInView:self.table];
    if (self.cardsArePinchedTogether) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            sender.scale = 1.0;
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            if (sender.scale > 1.0) {   // pinching apart?
                sender.scale = 1.0;
            }
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            if (sender.scale >= 1.0) {  // ended still pinching apart?
                [self.attachmentBehaviours removeAllObjects];
                [self.animator removeAllBehaviors];
                [self rearrangeCardViews];
                self.addCardsButton.enabled = YES;
                self.cardsArePinchedTogether = NO;
            }
        }
    } else {
        if (sender.state == UIGestureRecognizerStateBegan) {
            for (UIView *cardView in self.cardViews) {
                UIAttachmentBehavior *attachmentBehaviour = [[UIAttachmentBehavior alloc]initWithItem:cardView
                                                                                     attachedToAnchor:pinchLocation];
                [self.attachmentBehaviours addObject:attachmentBehaviour];
                [self.animator addBehavior:attachmentBehaviour];
                sender.scale = 1.0;
            }
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            if (sender.scale < 1.0) {  // pinching together?
                for (UIAttachmentBehavior *attachmentBehaviour in self.attachmentBehaviours) {
                    CGFloat scaleFactor = pow(sender.scale, 10.0);
                    attachmentBehaviour.length *= scaleFactor;
                    CGFloat lowerLimit = (arc4random() % 10);
                    attachmentBehaviour.length = (attachmentBehaviour.length > lowerLimit ? attachmentBehaviour.length : lowerLimit);
                }
            }
            sender.scale = 1.0;
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            self.addCardsButton.enabled = NO;
            self.cardsArePinchedTogether = YES;
        }
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
    if (self.cardsArePinchedTogether) {
        if (sender.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [sender translationInView:self.table];
            for (UIAttachmentBehavior *attachment in self.attachmentBehaviours) {
                CGPoint newAnchorPoint = {(attachment.anchorPoint.x + translation.x), (attachment.anchorPoint.y + translation.y)};
                attachment.anchorPoint = newAnchorPoint;
            }
            [sender setTranslation:CGPointZero inView:self.table];
        }
    }
}

#define NUMBER_OF_CARDS_TO_ADD 3

- (BOOL)addCards:(NSUInteger)numberOfCardsToAdd
{
    // adds cards to the game.
    // re-deals all the cards.
    BOOL success = YES;
    
    NSArray *newCards = [self.game addCards:numberOfCardsToAdd];
    
    if (newCards) {
        [self createCardViewsFromCards:newCards];
//        [self redealCardViews];
        [self rearrangeCardViews];
    } else {
        success = NO;
    }
    
    return success;
}

- (IBAction)addCards
{
    if (!self.cardsArePinchedTogether) {
        if (![self addCards:NUMBER_OF_CARDS_TO_ADD]) {
            self.addCardsButton.enabled = NO;
            NSLog(@"No more cards!");
        }
    }
}

- (void)clearTheTableAndDealNewCardsAnimated
// clears the table (animated) and deals new cards
{
    self.game = nil;    // this will cause new cards to be created in self.game's initialiser.
    CGPoint centre = CGPointMake(self.table.bounds.size.width, 0.0);  // the vanishing point!
    [UIView animateWithDuration:0.5
                     animations:^{
                         for (UIView *cardView in self.cardViews) {
                             cardView.center = centre;
                             cardView.alpha = 0.0;
                         }
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                             [self.cardViews removeAllObjects];
                             [self createCardViewsFromCards:self.game.cards];
                             [self redealCardViews];
                         }
                     }];
}

- (IBAction)newGame
{
    NSLog(@"newGame");
    [self clearTheTableAndDealNewCardsAnimated];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: 0"];
}

@end
