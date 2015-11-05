//
//  PreHomeViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 08/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "PreHomeViewController.h"
#import "HomeViewController.h"
#import "BookReaderController.h"

@interface PreHomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *infosView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIImageView *strat1;
@property (weak, nonatomic) IBOutlet UIImageView *strat2;
@property (weak, nonatomic) IBOutlet UIImageView *strat3;
@property (weak, nonatomic) IBOutlet UIImageView *strat4;
@property (weak, nonatomic) IBOutlet UIImageView *strat5;
@property (weak, nonatomic) IBOutlet UIImageView *strat6;
@property (weak, nonatomic) IBOutlet UIImageView *strat7;

@end

@implementation PreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rect1 = self.strat1.frame;
    rect2 = self.strat2.frame;
    rect3 = self.strat3.frame;
    rect4 = self.strat4.frame;
    rect5 = self.strat5.frame;
    rect6 = self.strat6.frame;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .01;
    self.motionManager.gyroUpdateInterval = .01;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];

    
    self.bookName.text = self.myBook.title;
    self.bookAuthor.text = self.myBook.author;
    
    UITapGestureRecognizer *tapScreen = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(continueRead:)];
    [self.view addGestureRecognizer:tapScreen];
    
    UISwipeGestureRecognizer *oneFingerSwipeUp = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(oneFingerSwipeUp:)] ;
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:oneFingerSwipeUp];
    
    self.myPupil->canGoingTo = [self.myPupil.currentChapter intValue];
    self.myPupil->nbMessageNotRead = 0;
}

-(void)outputAccelertionData:(CMAcceleration)acceleration {

}

-(void)outputRotationData:(CMRotationRate)rotation {
    rect1.origin.x = - rotation.x * 10 + 100;
    rect1.origin.y = - rotation.y * 10;
    self.strat1.frame = rect1;
    
    rect2.origin.x = - rotation.x * 10;
    rect2.origin.y = - rotation.y * 10;
    self.strat2.frame = rect2;
    
    rect3.origin.x = - rotation.x * 8;
    rect3.origin.y = - rotation.y * 8;
    self.strat3.frame = rect3;
    
    rect4.origin.x = - rotation.x * 6;
    rect4.origin.y = - rotation.y * 6;
    self.strat4.frame = rect4;
    
    rect5.origin.x = - rotation.x * 4;
    rect5.origin.y = - rotation.y * 4;
    self.strat5.frame = rect5;
    
    rect6.origin.x = - rotation.x * 2;
    rect6.origin.y = - rotation.y * 2;
    self.strat6.frame = rect6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToMainMenu"]){
        HomeViewController *controller = (HomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if ([segue.identifier isEqualToString:@"goToReadFromHome"]) {
        BookReaderController *controller = (BookReaderController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if ([segue.identifier isEqualToString:@"goToChapter"]) {
        BookReaderController *controller = (BookReaderController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}

- (void)continueRead:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"goToReadFromHome" sender:sender];
}

- (void)oneFingerSwipeUp:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"goToChapter" sender:sender];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.motionManager stopDeviceMotionUpdates];
    
    self.motionManager = nil;
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
