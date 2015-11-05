//
//  VideoHomeViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 08/05/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "VideoHomeViewController.h"
#import "PreHomeViewController.h"

@interface VideoHomeViewController ()

@end

@implementation VideoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *thePath=[[NSBundle mainBundle] pathForResource:@"videoIntro" ofType:@"mp4"];
    NSURL *theUrl=[NSURL fileURLWithPath:thePath];
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theUrl];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.moviePlayer prepareToPlay];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayer setShouldAutoplay:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoEnded) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [self.view addSubview:self.moviePlayer.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) videoEnded {
    [self performSegueWithIdentifier:@"goPreHomeFromVideo" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goPreHomeFromVideo"]){
        PreHomeViewController *controller = (PreHomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
