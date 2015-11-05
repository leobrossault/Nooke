//
//  ChapterNavViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 08/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pupils.h"
#import "Book.h"

@interface ChapterNavViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    UICollectionView *collectionView;
}

@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) NSString *currentChapter;

@end
