//
//  SuperMatchViewController.m
//  SuperMatch
//
//  Created by john on 03/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SuperMatchViewController.h"
#import "PlayingCardView.h"

@interface SuperMatchViewController ()
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) PlayingCardView *playingCardView;
@end

@implementation SuperMatchViewController

- (PlayingCardView *)playingCardView {
    if (!_playingCardView) {
        CGRect rect = CGRectMake(70, 70, 75, 90);
        _playingCardView = [[PlayingCardView alloc]initWithFrame:rect];
    }
    return _playingCardView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.playingCardView.rank = 13; // King
    self.playingCardView.suit = @"♥";
    [self.playingCardView addGestureRecognizer:[[UISwipeGestureRecognizer alloc]initWithTarget:self.playingCardView
                                                                                        action:@selector(swipe:)]];
    [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.playingCardView
                                                                                        action:@selector(pinch:)]];
    [self.cardView addSubview:self.playingCardView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
