//
//  PreHomeViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 08/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Pupils.h"
#import "Book.h"

@interface PreHomeViewController : UIViewController {
    CGRect rect1;
    CGRect rect2;
    CGRect rect3;
    CGRect rect4;
    CGRect rect5;
    CGRect rect6;
}

@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;

@end
