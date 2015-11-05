//
//  SendMessageViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 19/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pupils.h"
#import "Book.h"

@interface SendMessageViewController : UIViewController

@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) NSString *fromBook;

@end
