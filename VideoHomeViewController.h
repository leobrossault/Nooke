//
//  VideoHomeViewController.h
//  SchoolApp
//
//  Created by Léo Brossault on 08/05/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Pupils.h"
#import "Book.h"
#import "PupilsTeam.h"

@interface VideoHomeViewController : UIViewController

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;

@end
