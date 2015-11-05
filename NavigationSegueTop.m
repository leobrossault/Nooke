//
//  NavigationSegueTop.m
//  SchoolApp
//
//  Created by Léo Brossault on 10/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "NavigationSegueTop.h"

@implementation NavigationSegueTop

- (void)perform {
    UIViewController *source = (UIViewController *)self.sourceViewController;
    UIViewController *destination = (UIViewController *)self.destinationViewController;
    
    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.y = sourceFrame.size.height;
    
    CGRect destFrame = destination.view.frame;
    destFrame.origin.y = -destination.view.frame.size.height;
    destination.view.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [source.view.superview addSubview:destination.view];
    
    [UIView animateWithDuration:0.5
        animations:^{
            source.view.frame = sourceFrame;
            destination.view.frame = destFrame;
        }
        completion:^(BOOL finished) {
            UIWindow *window = source.view.window;
            [window setRootViewController:destination];
        }];
    
}



@end
