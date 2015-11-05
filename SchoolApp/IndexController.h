//
//  ViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 25/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pupils.h"
#import "Book.h"
#import "PupilsTeam.h"

@interface IndexController : UIViewController {
    int i;
    int k;
}

@property (nonatomic, strong) Pupils *myPupilExport;
@property (nonatomic, strong) Book *myBookExport;
@property (nonatomic, strong) PupilsTeam *myTeam;


@end

