//
//  AnimationView.m
//  FLAnimation
//
//  Created by Leaf on 2017/10/31.
//  Copyright © 2017年 leaf. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.contents = (id)[UIImage imageNamed:@"like_normal"].CGImage;
}

- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    CATransition *theAnimation=nil;
    
    if ([event isEqualToString:@"contents"]) {
        
        theAnimation = [[CATransition alloc] init];
        theAnimation.duration = 1.0;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        theAnimation.type = kCATransitionPush;
        theAnimation.subtype = kCATransitionFromRight;
    }
    return theAnimation;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.selected = !self.selected;
    if (self.selected) {
        self.layer.contents = (id)[UIImage imageNamed:@"like_selected"].CGImage;
    } else {
        self.layer.contents = (id)[UIImage imageNamed:@"like_normal"].CGImage;
    }
}

@end
