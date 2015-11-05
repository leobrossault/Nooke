//
//  Activity.h
//  SchoolApp
//
//  Created by Léo Brossault on 01/05/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *order;
@property (nonatomic, strong) NSArray *answer;

@end
