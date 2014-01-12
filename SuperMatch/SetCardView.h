//
//  SetCardView.h
//  SuperMatch
//
//  Created by john on 06/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

// 1, 2 or 3 for each property
@property (nonatomic) NSUInteger numberOfShapes;
@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger colour;
@property (nonatomic) NSUInteger shading;
@property (nonatomic, getter = isChosen) BOOL chosen;

@end
