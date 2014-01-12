//
//  PlayingCardView.h
//  SuperCard
//
//  Created by john on 02/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;

@end
