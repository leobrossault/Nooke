//
//  TeamViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 07/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pupils.h"
#import "Book.h"
#import "PupilsTeam.h"

@interface TeamViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
    UICollectionView *collectionView;
    UICollectionView *collectionViewMessage;
    int i;
    CGRect frameMessage;
}


@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) NSArray *messages;

@property (strong, nonatomic) UIView *teamBottomBorder;
@property (strong, nonatomic) UIView *messageBottomBorder;

- (NSArray *)getMessageFromTeam: (NSString *) team;

@end
