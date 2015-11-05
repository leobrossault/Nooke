//
//  NavigationNoTransition.m
//  SchoolApp
//
//  Created by Léo Brossault on 08/05/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "NavigationNoTransition.h"

@implementation NavigationNoTransition

- (void)perform {
    UIViewController *source = (UIViewController *)self.sourceViewController;
    UIViewController *destination = (UIViewController *)self.destinationViewController;
    
    UIWindow *window = source.view.window;
    [window setRootViewController:destination];
    
}

@end
