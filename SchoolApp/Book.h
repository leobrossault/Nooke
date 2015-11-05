//
//  Book.h
//  SchoolApp
//
//  Created by Léo Brossault on 30/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *nbChapter;
@property (nonatomic, strong) NSArray *chapter;

@end
