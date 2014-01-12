//
//  background.m
//  SuperMatch
//
//  Created by john on 23/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "background.h"

@implementation background

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:(self.bounds.size.width * 0.05)];
    [roundedRect addClip];
    [[UIColor colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0] setFill]; // Moss colour (to match the card table)
    [roundedRect fill];
}

#pragma mark - Initialisation

-(void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
//    [self setNeedsDisplay];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

@end
