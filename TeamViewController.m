//
//  TeamViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 07/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "TeamViewController.h"
#import "ProfilViewController.h"
#import "SendMessageViewController.h"
#import "Message.h"
#import <RestKit/RestKit.h>

@interface TeamViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnSendMessage;
@property (weak, nonatomic) IBOutlet UIImageView *teamStrat1;
@property (weak, nonatomic) IBOutlet UIImageView *teamStrat2;
@property (weak, nonatomic) IBOutlet UIImageView *teamStrat3;
@property (weak, nonatomic) IBOutlet UIImageView *teamStrat4;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIView *btnViewTeam;
@property (weak, nonatomic) IBOutlet UIView *btnViewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgTeam;
@property (weak, nonatomic) IBOutlet UIImageView *imgMessage;
@property (weak, nonatomic) IBOutlet UIView *teamView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollMessages;

@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.teamLabel.text = [NSString stringWithFormat:@"équipe %@", self.myPupil.team];
    self.scrollMessages.delegate = self;
    self.scrollMessages.scrollEnabled = YES;

    /* INIT BUTTON VIEW */
    self.teamBottomBorder = [[UIView alloc] init];
    self.teamBottomBorder.backgroundColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
    self.teamBottomBorder.frame = CGRectMake(0, self.btnViewTeam.frame.size.height - 5.0, self.btnViewTeam.frame.size.width, 5.0f);
    [self.btnViewTeam addSubview: self.teamBottomBorder];
    
    self.messageBottomBorder = [[UIView alloc] init];
    self.messageBottomBorder.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1];
    self.messageBottomBorder.frame = CGRectMake(0, self.btnViewMessage.frame.size.height - 5.0, self.btnViewMessage.frame.size.width, 5.0f);
    [self.btnViewMessage addSubview: self.messageBottomBorder];
    
    UITapGestureRecognizer *goTeam = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tab:)];
    [goTeam setNumberOfTapsRequired: 1];
    [self.btnViewTeam addGestureRecognizer:goTeam];
    
    UITapGestureRecognizer *goMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tab:)];
    [goMessage setNumberOfTapsRequired: 1];
    [self.btnViewMessage addGestureRecognizer:goMessage];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [self.teamView addSubview:collectionView];
    
    CGRect frame = [collectionView frame];
    frame.origin.x = 100;
    frame.origin.y = 50;
    frame.size.width = self.teamView.frame.size.width - 100;
    frame.size.height = self.teamView.frame.size.height;
    [collectionView setFrame:frame];
    
    /* INIT MESSAGES */
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(refreshMessages:)  userInfo:nil repeats:YES];
    self.messages = [self getMessageFromTeam: self.myPupil.team];
    
    UICollectionViewFlowLayout *layoutMessage = [[UICollectionViewFlowLayout alloc] init];
    collectionViewMessage = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layoutMessage];
    
    [collectionViewMessage setDataSource:self];
    [collectionViewMessage setDelegate:self];
    
    [collectionViewMessage registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellMessage"];
    [collectionViewMessage setBackgroundColor:[UIColor clearColor]];
    [self.scrollMessages addSubview:collectionViewMessage];
    
    frameMessage = [collectionViewMessage frame];
    frameMessage.origin.x = 100;
    frameMessage.origin.y = 50;
    frameMessage.size.width = self.messageView.frame.size.width - 100;
    frameMessage.size.height = 200 * [self.messages count];
    [collectionViewMessage setFrame:frameMessage];
    self.scrollMessages.contentSize = CGSizeMake(self.view.frame.size.width, 200 * [self.messages count]);

    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(oneFingerSwipeLeft:)] ;
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshMessages: (NSTimer *)timer {
    
    self.messages = [self getMessageFromTeam: self.myPupil.team];
    
    UICollectionViewFlowLayout *layoutMessage = [[UICollectionViewFlowLayout alloc] init];
    collectionViewMessage = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layoutMessage];
    
    [collectionViewMessage setDataSource:self];
    [collectionViewMessage setDelegate:self];
    
    [collectionViewMessage registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellMessage"];
    [collectionViewMessage setBackgroundColor:[UIColor clearColor]];
    [self.scrollMessages addSubview:collectionViewMessage];
  
    frameMessage.size.height = 200 * [self.messages count];
    [collectionViewMessage setFrame:frameMessage];
}

- (NSInteger)collectionView:(UICollectionView *)myCollectionView numberOfItemsInSection:(NSInteger)section {
    if (myCollectionView == collectionView) {
        return self.team.count;
    } else {
        return self.messages.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)myCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (myCollectionView == collectionView) {
        UICollectionViewCell *cell=[myCollectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
        if ([self.team objectAtIndex: indexPath.row] != [NSNull null]) {
            PupilsTeam *pupilTeam = [self.team objectAtIndex: indexPath.row];
        
            if (pupilTeam._id != self.myPupil._id) {
                UIView *otherPupil = [[UIView alloc] init];
                UILabel *firstLetter = [[UILabel alloc] init];
                UILabel *fullName = [[UILabel alloc] init];
                UILabel *currentChapter = [[UILabel alloc] init];
                UIView *progressBar = [[UIView alloc] init];
                UIView *bar = [[UIView alloc] init];
            
                float percent = ([pupilTeam.currentChapter floatValue]/[self.myBook.nbChapter floatValue]) * 100;
                float width = (lroundf(percent) / 100.0) * 143.0 ;
            
                [firstLetter setFrame:CGRectMake(0, 0, 50, 50)];
                [fullName setFrame:CGRectMake(88, 15, 400, 50)];
                [currentChapter setFrame:CGRectMake(300, 65, 150, 25)];
                [progressBar setFrame:CGRectMake(95, 65, 142, 20)];
                [bar setFrame: CGRectMake(0, 0, width, 20)];
            
                firstLetter.backgroundColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
                firstLetter.layer.cornerRadius = 25;
                firstLetter.layer.masksToBounds = YES;
                firstLetter.textColor = [UIColor whiteColor];
                firstLetter.textAlignment = NSTextAlignmentCenter;
                firstLetter.font = [UIFont fontWithName:@"Museo-300" size: 30];
                firstLetter.text = [NSString stringWithFormat: @"%@", [pupilTeam.firstName substringToIndex:1]];
            
                fullName.text = [NSString stringWithFormat:@"%@ %@", pupilTeam.firstName, pupilTeam.lastName];
                fullName.textColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
                fullName.font = [UIFont fontWithName:@"Museo-300" size: 30];
                
                if ([pupilTeam.currentChapter intValue] + 1 == 5) {
                    currentChapter.text = @"Livre terminé";
                } else {
                   currentChapter.text = [NSString stringWithFormat:@"Chapitre %d", [pupilTeam.currentChapter intValue] + 1];
                }
                
                currentChapter.textColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
                currentChapter.font = [UIFont fontWithName:@"Museo-300" size: 20];
            
                progressBar.layer.borderWidth = 1.0;
                progressBar.layer.borderColor = [UIColor colorWithRed:0.969 green:0.925 blue:0.933 alpha:1].CGColor;
                progressBar.layer.cornerRadius = 10;
                progressBar.layer.masksToBounds = YES;
            
                bar.backgroundColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
            
                [progressBar addSubview: bar];
                [otherPupil addSubview: progressBar];
                [otherPupil addSubview: firstLetter];
                [otherPupil addSubview: fullName];
                [otherPupil addSubview: currentChapter];
      
                [cell addSubview: otherPupil];
            }
        }
    
        return cell;
    } else {
        UICollectionViewCell *cell = [myCollectionView dequeueReusableCellWithReuseIdentifier:@"cellMessage" forIndexPath:indexPath];
        
        UIView *messagesView = [[UIView alloc] init];
        UILabel *firstLetterMessage = [[UILabel alloc] init];
        UILabel *titleMessage = [[UILabel alloc] init];
        UILabel *textMessage = [[UILabel alloc] init];
        
        [firstLetterMessage setFrame:CGRectMake(20, 20, 50, 50)];
        [titleMessage setFrame:CGRectMake(100, 20, 200, 20)];
        [textMessage setFrame:CGRectMake(100, 45, 500, 50)];
        
        firstLetterMessage.layer.cornerRadius = 25;
        firstLetterMessage.layer.masksToBounds = YES;
        firstLetterMessage.textColor = [UIColor whiteColor];
        firstLetterMessage.textAlignment = NSTextAlignmentCenter;
        firstLetterMessage.font = [UIFont fontWithName:@"Museo-300" size: 30];
        firstLetterMessage.text = [NSString stringWithFormat: @"%@", [[[self.messages objectAtIndex: indexPath.row]  objectForKey: @"authorName"] substringToIndex: 1]];
        
        titleMessage.text = [NSString stringWithFormat: @"%@", [[self.messages objectAtIndex: indexPath.row] objectForKey: @"title"]];
        titleMessage.font = [UIFont fontWithName:@"Museo-700" size:20];
        
        UITapGestureRecognizer *okRead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(okRead:)];
        [okRead setNumberOfTapsRequired: 1];
        [cell addGestureRecognizer:okRead];
        
        titleMessage.textColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
        firstLetterMessage.backgroundColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
        
        textMessage.text = [NSString stringWithFormat: @"%@", [[self.messages objectAtIndex: indexPath.row] objectForKey: @"text"]];
        textMessage.textColor = [UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1];
        textMessage.font = [UIFont fontWithName:@"Museo-300" size: 14];
        textMessage.numberOfLines = 0;
        
        [messagesView addSubview: firstLetterMessage];
        [messagesView addSubview: titleMessage];
        [messagesView addSubview: textMessage];
//        cell.layer.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1].CGColor;
        [cell addSubview: messagesView];
      return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)myCollectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (myCollectionView == collectionView) {
        return CGSizeMake(self.view.frame.size.width - 100, 150);
    } else {
        return CGSizeMake(self.view.frame.size.width - 100, 150);
    }
    
}

- (void) okRead: (UITapGestureRecognizer *) sender {
    UIView *selectedView = (UIView *)sender.view;
    selectedView.backgroundColor = [UIColor clearColor];
    
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    fade.fromValue = (id)[UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1].CGColor;
    fade.toValue = (id)[UIColor clearColor].CGColor;
    [fade setDuration:1];
    [selectedView.layer addAnimation:fade forKey:@"fadeAnimation"];
//    NSString *url = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/message/okRead/%@", self.myPupil._id];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [conn start];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"profilFromTeam"]){
        ProfilViewController *controller = (ProfilViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if([segue.identifier isEqualToString:@"goToSendMessage"]){
        SendMessageViewController *controller = (SendMessageViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)sender {
    [self animateStrat1: @"left"];
    [self animateStrat2: @"left"];
    [self animateStrat3: @"left"];
    [self animateStrat4: @"left"];
    [self performSegueWithIdentifier:@"profilFromTeam" sender:sender];
}

- (IBAction)goToSendMessage:(id)sender {
    [self performSegueWithIdentifier:@"goToSendMessage" sender:sender];
}

- (NSArray *)getMessageFromTeam: (NSString *) team {
    NSString *str = [NSString stringWithFormat: @"http://macbook-pro-de-leo.local:8080/app/pupil/message/%@", self.myPupil._id];
    NSURL *url = [NSURL URLWithString: str];
    NSData *data = [NSData dataWithContentsOfURL: url];
    NSError *error = nil;
    NSArray *messagesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    return messagesArray;
}

- (void)tab:(UITapGestureRecognizer *)sender {
    UIView *selectedView = (UIView *)sender.view;
    UIImage *imageTeam;
    UIImage *imageMessage;
    if (selectedView.tag == 1) {
        imageTeam = [UIImage imageNamed:@"team"];
        imageMessage = [UIImage imageNamed:@"message_inactiv"];
        [self.imgTeam setImage: imageTeam];
        [self.imgMessage setImage: imageMessage];
        
        self.teamBottomBorder.backgroundColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
        self.messageBottomBorder.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1];
        
        [self.view bringSubviewToFront: self.teamView];
        self.teamView.hidden = false;
        self.messageView.hidden = true;
    } else {
        imageTeam = [UIImage imageNamed:@"team_inactiv"];
        imageMessage = [UIImage imageNamed:@"message"];
        [self.imgTeam setImage: imageTeam];
        [self.imgMessage setImage: imageMessage];

        self.teamBottomBorder.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1];
        self.messageBottomBorder.backgroundColor = [UIColor colorWithRed:0.89 green:0.655 blue:0.624 alpha:1];
        
        [self.view bringSubviewToFront: self.messageView];
        self.teamView.hidden = true;
        self.messageView.hidden = false;
    }
}


- (void) animateStrat1:(NSString *)direction {
    CGPoint origin = self.teamStrat1.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.teamStrat1.center.x-500, self.teamStrat1.center.y);
        
    } else {
        target = CGPointMake(self.teamStrat1.center.x+500, self.teamStrat1.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.teamStrat1.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat2:(NSString *)direction {
    CGPoint origin = self.teamStrat2.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.teamStrat2.center.x-500, self.teamStrat2.center.y);
        
    } else {
        target = CGPointMake(self.teamStrat2.center.x+500, self.teamStrat2.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    [bounce setBeginTime:CACurrentMediaTime()+.2];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.teamStrat2.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat3:(NSString *)direction {
    CGPoint origin = self.teamStrat3.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.teamStrat3.center.x-500, self.teamStrat3.center.y);
        
    } else {
        target = CGPointMake(self.teamStrat3.center.x+500, self.teamStrat3.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2;
    [bounce setBeginTime:CACurrentMediaTime()+.5];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.teamStrat3.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat4:(NSString *)direction {
    CGPoint origin = self.teamStrat4.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.teamStrat4.center.x-500, self.teamStrat4.center.y);
        
    } else {
        target = CGPointMake(self.teamStrat4.center.x+500, self.teamStrat4.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 1.5;
    [bounce setBeginTime:CACurrentMediaTime()+1];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.teamStrat4.layer addAnimation:bounce forKey:@"position"];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}


@end
