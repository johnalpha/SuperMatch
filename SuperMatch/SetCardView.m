//
//  SetCardView.m
//  SuperMatch
//
//  Created by john on 06/12/2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - properties

- (void)setNumberOfShapes:(NSUInteger)numberOfShapes {
    if (_numberOfShapes != numberOfShapes) {
        _numberOfShapes = numberOfShapes;
        [self setNeedsDisplay];
    }
}

- (void)setShape:(NSUInteger)shape {
    if (_shape != shape) {
        _shape = shape;
        [self setNeedsDisplay];
    }
}

- (void)setColour:(NSUInteger)colour {
    if (_colour != colour) {
        _colour = colour;
        [self setNeedsDisplay];
    }
}

- (void)setShading:(NSUInteger)shading {
    if (_shading != shading) {
        _shading = shading;
        [self setNeedsDisplay];
    }
}

- (void)setChosen:(BOOL)chosen {
    if (_chosen != chosen) {
        _chosen = chosen;
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing

- (void)setStrokeAndFillColours {
    UIColor *colour;
    switch (self.colour) {
        case 1:
            colour = [UIColor redColor];
            [colour setStroke];
            if (self.shading == 2) colour = [UIColor colorWithPatternImage:[UIImage imageNamed:@"redStriped"]];
            [colour setFill];
            break;
        case 2:
            colour = [UIColor colorWithRed:0.0 green:0.75 blue:0.0 alpha:1.0];
            [colour setStroke];
            if (self.shading == 2) colour = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenStriped"]];
            [colour setFill];
            break;
        case 3:
            colour = [UIColor purpleColor];
            [colour setStroke];
            if (self.shading == 2) colour = [UIColor colorWithPatternImage:[UIImage imageNamed:@"purpleStriped"]];
            [colour setFill];
            break;
        default:
            break;
    }
    
}


- (UIBezierPath *) squiggleInRect:(CGRect)r {
    // alien code!
    // cribbed from GitHub
    // ignores CGRect r, but gives result for r = [self centredRect] (apparently!)
    
    #define SYMBOL_SCALE_X 2
    #define SYMBOL_SCALE_Y 7
    #define SIZE_OF_OVAL_CURVE 10
    
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGPoint start = CGPointMake(middle.x + (middle.x / SYMBOL_SCALE_X), middle.y - (middle.y / SYMBOL_SCALE_Y));
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    
    [path addCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint1:CGPointMake(middle.x, middle.y + (middle.y / SYMBOL_SCALE_Y) + (middle.y / SYMBOL_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), start.y) controlPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    
    [path addCurveToPoint:CGPointMake(start.x, start.y) controlPoint1:CGPointMake(middle.x, middle.y - (middle.y / SYMBOL_SCALE_Y) - (middle.y / SYMBOL_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    [path closePath];
    
    return path;
}

- (UIBezierPath *) diamondInRect:(CGRect)r {
    CGPoint p1 = CGPointMake(r.origin.x, r.origin.y + (r.size.height * 0.5));
    CGPoint p2 = CGPointMake((r.origin.x + r.size.width * 0.5), r.origin.y);
    CGPoint p3 = CGPointMake((r.origin.x + r.size.width), p1.y);
    CGPoint p4 = CGPointMake(p2.x, (r.origin.y + r.size.height));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    [path closePath];
    return path;
}

- (UIBezierPath *) ovalInRect:(CGRect)r {
    return [UIBezierPath bezierPathWithOvalInRect:r];
}

#define INSET 0.2
#define HEIGHT 0.175

- (CGRect)centredRect {
    // centred in self.bounds
    CGFloat width = (self.bounds.size.width - 2.0 * self.bounds.size.width * INSET);
    CGFloat height = self.bounds.size.height * HEIGHT;
    CGFloat x0 = self.bounds.size.width * INSET;                    // origin.x for all shapes (stacked vertically)
    CGFloat y0 = (self.bounds.size.height * 0.5) - (height * 0.5);  // origin.y for the rectangle at the centre
    return CGRectMake(x0, y0, width, height);
}

- (UIBezierPath *)centredPath {
    UIBezierPath *path;
    switch (self.shape) {
        case 1:
            path = [self squiggleInRect:[self centredRect]];
            break;
        case 2:
            path = [self diamondInRect:[self centredRect]];
            break;
        case 3:
            path = [self ovalInRect:[self centredRect]];
            break;
    }
    return path;
}

- (void)drawPath:(UIBezierPath *)path {
    [path stroke];
    if (self.shading != 1) [path fill];
}

#define SEPARATION 0.075

- (void)drawShapes {
    [self setStrokeAndFillColours];
    CGFloat y_increment = self.bounds.size.height * HEIGHT + self.bounds.size.height * SEPARATION;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath *path = [self centredPath];
    switch (self.numberOfShapes) {
        case 1:
            [self drawPath:path];
            break;
        case 2:
            CGContextTranslateCTM(context, 0.0, -(y_increment * 0.5));
            [self drawPath:path];
            
            CGContextTranslateCTM(context, 0.0, +y_increment);
            [self drawPath:path];
            break;
        case 3:
            CGContextTranslateCTM(context, 0.0, -y_increment);
            [self drawPath:path];
            
            CGContextTranslateCTM(context, 0.0, +y_increment);
            [self drawPath:path];
            
            CGContextTranslateCTM(context, 0.0, +y_increment);
            [self drawPath:path];
            break;
    }
    
    CGContextRestoreGState(context);
}

#define CORNER_RADIUS 0.2

- (void)drawBlankCard {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:(self.bounds.size.width * CORNER_RADIUS)];
    
    [[UIColor whiteColor] setFill];
    if (self.isChosen) [[UIColor yellowColor] setFill];
    
    [[UIColor blackColor] setStroke];
        
    [path addClip];
    [path fill];
    [path stroke];
    
}

- (void)drawRect:(CGRect)rect
{
    [self drawBlankCard];
    [self drawShapes];
}

#pragma mark - Initialisation

-(void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib {
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
