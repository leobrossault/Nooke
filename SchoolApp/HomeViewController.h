//
//  HomeViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 25/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pupils.h"
#import "Book.h"

@interface HomeViewController : UIViewController {
    int j;
}

@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end
