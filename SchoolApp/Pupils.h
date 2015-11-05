//
//  Pupils.h
//  SchoolApp
//
//  Created by Léo Brossault on 25/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pupils : NSObject {
    @public int canGoingTo;
    @public int nbMessageNotRead;
}

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *passwordApp;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *classroom;
@property (nonatomic, strong) NSString *currentChapter;
@property (nonatomic, strong) NSString *team;
@property (nonatomic, strong) NSNumber *readTime;
@property (nonatomic, strong) NSMutableArray *wordsBag;



@end
