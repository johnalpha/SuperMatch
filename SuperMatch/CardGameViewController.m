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
@property (strong, nonatomic, readwrite) CardMatchingGame *game;
@property (strong, nonatomic, readwrite) NSMutableArray *cardViews; // of UIViews
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSMutableArray *attachmentBehaviours; // of UIAttachmentBehaviours
@property (nonatomic) BOOL cardsArePinchedTogether;
@end

@implementation CardGameViewController

#pragma mark - abstract methods

- (void)setUp
{
}

- (Deck *)createDeck
{
    return nil;
}

- (UIView *)cardViewInRectangle:(CGRect)rect
{
    return nil;
}

- (void)setCardView:(UIView *)cardView usingCard:(Card *)card
{
}

#pragma mark - properties

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsToDeal
                                                  usingDeck:[self createDeck]];
        _game.numberOfCardsToMatch = self.numberOfCardsToMatch;
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
    [super viewDidLoad];
    [self setUp];
    [self createCardViewsFromCards:self.game.cards];
    self.cardsArePinchedTogether = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.cardsArePinchedTogether) [self redealCardViews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
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

#pragma mark -

- (void)createCardViewsFromCards:(NSArray *)cards
// cardViews will be zero size and centred at the lower left-hand corner of the table.
{
    for (Card *card in cards) {
        CGPoint location = CGPointMake(0.0, self.table.bounds.size.height);
        UIView *cardView = [self cardViewInRectangle:CGRectZero];
        if (cardView) {
            [self setCardView:cardView usingCard:card];
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(handleTap:)]];
            cardView.center = location;
            cardView.tag = [self.game indexForCard:card];
            
            [self.cardViews addObject:cardView];
            [self.table addSubview:cardView];
        }
    }
}

#define MINIMUM_COLUMN_COUNT 6

- (BOOL)setGrid
// tries to set a grid to display the existing set of card views.
// returns success or failure.
{
    self.grid.size = self.table.bounds.size;
    self.grid.cellAspectRatio = self.cardAspectRatio;
    self.grid.minimumNumberOfCells = [self.cardViews count];
    self.grid.maxCellWidth = self.table.bounds.size.width / MINIMUM_COLUMN_COUNT;
    return (self.grid.inputsAreValid ? YES : NO);
}

- (void)redealCardViews
// creates new grid and deals (sequentially) existing cardViews onto it.
{
    if ([self setGrid]) {
        [self dealCardViews];
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
    self.cardsArePinchedTogether = NO;
}

- (void)rearrangeCardViews
// creates new grid and arranges (simultaneously) existing cardViews onto it.
{
    if ([self setGrid]) {
        [self arrangeCardViews];
    } else {
        NSLog(@"rearrangeCardViews: grid is invalid");
    }
}

- (void)arrangeCardViews
// arranges onto existing grid, animated.
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         NSUInteger index = 0;
                         while (index < [self.cardViews count]) {
                             UIView *cardView = self.cardViews[index];
                             NSUInteger row = index / self.grid.columnCount;
                             NSUInteger column = index % self.grid.columnCount;
                             cardView.frame = [self.grid frameOfCellAtRow:row inColumn:column];
                             index++;
                         }
                     }];
    self.cardsArePinchedTogether = NO;
}

- (void)updateCardViews {
    for (UIView *cardView in self.cardViews) {
        [self setCardView:cardView usingCard:[self.game cardAtIndex:cardView.tag]];
    }
}

- (void)updateUI
{
    [self updateCardViews];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"handleTap");
    if (self.cardsArePinchedTogether) {
        [self.attachmentBehaviours removeAllObjects];
        [self.animator removeAllBehaviors];
        [self rearrangeCardViews];
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
                CGFloat scaleFactor = pow(sender.scale, 5.0);
                for (UIAttachmentBehavior *attachmentBehaviour in self.attachmentBehaviours) {
                    attachmentBehaviour.length *= scaleFactor;
                }
                sender.scale = 1.0;
            }
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            if (sender.scale >= 1.0) {  // still pinching apart?
                [self.attachmentBehaviours removeAllObjects];
                [self.animator removeAllBehaviors];
                [self rearrangeCardViews];
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
                CGFloat scaleFactor = pow(sender.scale, 10.0);
                for (UIAttachmentBehavior *attachmentBehaviour in self.attachmentBehaviours) {
                    attachmentBehaviour.length *= scaleFactor;
                    CGFloat lowerLimit = (arc4random() % 10);
                    attachmentBehaviour.length = (attachmentBehaviour.length > lowerLimit ? attachmentBehaviour.length : lowerLimit);
                }
            }
            sender.scale = 1.0;
        } else if (sender.state == UIGestureRecognizerStateEnded) {
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

- (void)clearTheTableAndDealNewCardsAnimated
// clears the table (animated) and deals new cards
{
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
    self.game = nil;    // this will cause new cards to be created in self.game's initialiser.
    [self clearTheTableAndDealNewCardsAnimated];
    [self updateUI];
}

@end
