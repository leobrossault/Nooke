//
//  Message.h
//  SchoolApp
//
//  Created by Léo Brossault on 20/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *team;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *object;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *isReading;

@end
