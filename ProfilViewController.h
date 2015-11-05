//
//  ProfilViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 07/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pupils.h"
#import "Book.h"

@interface ProfilViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) NSArray *wordsSection;
@property (nonatomic, strong) NSMutableDictionary *section;

@property (strong, nonatomic) UIView *successBottomBorder;
@property (strong, nonatomic) UIView *wordsBottomBorder;

@end
