//
//  NavigationSegueLeftMenu.m
//  SchoolApp
//
//  Created by Léo Brossault on 08/05/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "NavigationSegueLeftMenu.h"

@implementation NavigationSegueLeftMenu

- (void)perform {
    UIViewController *source = (UIViewController *)self.sourceViewController;
    UIViewController *destination = (UIViewController *)self.destinationViewController;
    
    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.x = sourceFrame.size.width;
    
    CGRect destFrame = destination.view.frame;
    destFrame.origin.x = -destination.view.frame.size.width;
    destination.view.frame = destFrame;
    
    destFrame.origin.x = 0;
    
    [source.view.superview addSubview:destination.view];
    
    [UIView animateWithDuration: 2.5
     
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
