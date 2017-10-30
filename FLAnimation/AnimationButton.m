//
//  AnimationButton.m
//  FLAnimation
//
//  Created by Leaf on 2017/10/29.
//  Copyright © 2017年 leaf. All rights reserved.
//

#import "AnimationButton.h"

@interface AnimationButton () <CAAnimationDelegate>
{
    
}

@property (nonatomic, strong) CALayer *backLayer;
@property (nonatomic, strong) CALayer *scaleLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CALayer *containerLayer;

@end

@implementation AnimationButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initLayer];
    }
    return self;
}

- (void)initLayer {
    self.backLayer = [CALayer layer];
    self.backLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:self.backLayer];
    self.scaleLayer = [CALayer layer];
    self.scaleLayer.contents = (__bridge id)[UIImage imageNamed:@"like_normal"].CGImage;
    self.backLayer.mask = self.scaleLayer;
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.strokeColor = [UIColor redColor].CGColor;
    self.circleLayer.fillColor = [UIColor whiteColor].CGColor;
    self.circleLayer.lineWidth = 1.f;
    [self.layer addSublayer:self.circleLayer];
}

- (void)startAnimation {
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.3f;
    pathAnimation.values = @[(__bridge id)[self circleWithCenter:self.circleLayer.position radius:1].CGPath,
                             (__bridge id)[self circleWithCenter:self.circleLayer.position radius:self.circleLayer.frame.size.width/2 * 1.5].CGPath];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.delegate = self;
    [self.circleLayer addAnimation:pathAnimation forKey:@"circle"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (anim == [self.circleLayer animationForKey:@"circle"]) {
        [self.circleLayer removeAllAnimations];
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@0.5, @1, @0.8, @1];
        [self.backLayer addAnimation:scaleAnimation forKey:@"scale"];
        
        CGFloat angle = M_PI * 2 / 14;
        
        
        self.containerLayer = [CALayer layer];
        self.containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:self.containerLayer];
        
        for (int i = 0; i < 14; i++) {
            
            CGPoint center = [self centerWithAngle:angle * i radius:self.bounds.size.width/2 * 1.5];
            CGPoint end = [self centerWithAngle:angle * i radius:self.bounds.size.width/2 * 1.8];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.fillColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.f].CGColor;
            layer.path = [self circleWithCenter:center radius:10].CGPath;
            [self.containerLayer addSublayer:layer];
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            CGFloat radius = 10.f;
            if (i % 2 == 1) {
                radius = 5.f;
            }
            animation.values = @[(id)[self circleWithCenter:center radius:radius].CGPath,
                                 (id)[self circleWithCenter:end radius:0.1].CGPath];
            animation.duration = 0.7f;
            animation.removedOnCompletion = YES;
            animation.delegate = self;
            [layer addAnimation:animation forKey:@"path animation"];
        }
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.duration = 0.7f;
        rotationAnimation.toValue = [NSNumber numberWithFloat:angle];
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.delegate = self;
        [self.containerLayer addAnimation:rotationAnimation forKey:@"rotation"];
        
    } 
    else if ([self.containerLayer animationForKey:@"rotation"] == anim) {
        [self.backLayer removeAllAnimations];
        [self.containerLayer removeAllAnimations];
        [self.containerLayer removeFromSuperlayer];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.selected = !self.selected;
    
    if (self.selected) {
        
        [self startAnimation];
        self.backLayer.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
        
    } else {
        
        self.backLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
}

- (void)layoutSubviews {
    self.backLayer.frame = self.bounds;
    self.scaleLayer.frame = self.bounds;
    self.circleLayer.frame = self.bounds;
}

- (UIBezierPath *)circleWithCenter:(CGPoint)center radius:(CGFloat)radius {
    
    UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    return pointPath;
}

- (CGPoint)centerWithAngle:(CGFloat)angle radius:(CGFloat)radius {
    
    CGFloat x = self.bounds.size.width/2 + cosf(angle) * radius;
    CGFloat y = self.bounds.size.height/2 - sinf(angle) * radius;
    
    return CGPointMake(x, y);
}

@end
