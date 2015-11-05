//
//  ChapterNavViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 08/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "ChapterNavViewController.h"
#import "PreHomeViewController.h"
#import "BookReaderController.h"

@interface ChapterNavViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleBook;
@property (weak, nonatomic) IBOutlet UILabel *authorBook;

@end

@implementation ChapterNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleBook.text = self.myBook.title;
    self.authorBook.text = self.myBook.author;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:collectionView];
    
    CGRect frame = [collectionView frame];
    frame.origin.x = 167;
    frame.origin.y = 300;
    frame.size.width = 450;
    frame.size.height = 1500;
    [collectionView setFrame:frame];
    
    UISwipeGestureRecognizer *oneFingerSwipeDown = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(oneFingerSwipeDown:)] ;
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:oneFingerSwipeDown];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myBook.chapter.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)myCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[myCollectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    UIView *chapterView = [[UIView alloc] init];
    UIImageView *chapterImageView;
    UIImage *chapterImage = [[UIImage alloc] init];
    UILabel *chapterTitle = [[UILabel alloc] init];
    UILabel *chapterResume = [[UILabel alloc] init];
    
    [chapterView setFrame:CGRectMake(0, 0, 173, 204)];
    chapterView.tag = indexPath.row;
    
    if (indexPath.row % 2) {
        if (self.myPupil->canGoingTo >= indexPath.row) {
            chapterImage = [UIImage imageNamed:@"img_chapter_1"];
        } else {
            chapterImage = [UIImage imageNamed:@"img_chapter_2_lock"];
        }
    } else {
        if (self.myPupil->canGoingTo >= indexPath.row) {
            chapterImage = [UIImage imageNamed:@"img_chapter_2"];
        } else {
            chapterImage = [UIImage imageNamed:@"img_chapter_1_lock"];
        }
    }
    chapterImageView = [[UIImageView alloc] initWithImage: chapterImage];
    CGRect imgFrame = chapterImageView.frame;
    imgFrame.origin.x = 20;
    chapterImageView.frame = imgFrame;
    
    [chapterTitle setFrame:CGRectMake(0, 126, chapterView.frame.size.width, 22)];
    chapterTitle.font = [UIFont fontWithName:@"Museo-700" size:17];
    chapterTitle.textAlignment = NSTextAlignmentCenter;
    chapterTitle.text = [NSString stringWithFormat:@"%@",[[self.myBook.chapter objectAtIndex: indexPath.row] objectForKey:@"titleChapter"]];
    chapterTitle.textColor = [UIColor colorWithRed:0.62 green:0.533 blue:0.541 alpha:1];
    
    [chapterResume setFrame:CGRectMake(0, 154, chapterView.frame.size.width, 40)];
    chapterResume.font = [UIFont fontWithName:@"Museo-300" size:13];
    chapterResume.textAlignment = NSTextAlignmentCenter;
    chapterResume.numberOfLines = 0;
    chapterResume.textColor = [UIColor colorWithRed:0.62 green:0.533 blue:0.541 alpha:1];
    chapterResume.text = @"Dans lequel Phileas Fogg et Passepartout s’acceptent. ";
    
    if (self.myPupil->canGoingTo >= indexPath.row) {
        UITapGestureRecognizer *goToChapter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goRead:)];
        [goToChapter setNumberOfTapsRequired: 1];
        [chapterView addGestureRecognizer:goToChapter];
    }
    
    [chapterView addSubview: chapterImageView];
    [chapterView addSubview: chapterTitle];
    [chapterView addSubview: chapterResume];
    [cell addSubview:chapterView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(180 , 250);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goReadWithChapter"]) {
        BookReaderController *controller = (BookReaderController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
        controller.myPupil.currentChapter = self.currentChapter;
    } else if ([segue.identifier isEqualToString:@"goToPreHomeFromChapter"]) {
        PreHomeViewController *controller = (PreHomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
        controller.myPupil.currentChapter = self.currentChapter;
    }
}

- (void)oneFingerSwipeDown:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"goToPreHomeFromChapter" sender:sender];
}

- (void)goRead:(UITapGestureRecognizer *)sender {
    UIView *selectedView = (UIView *)sender.view;
    self.currentChapter = [NSString stringWithFormat:@"%ld", (long)selectedView.tag];
    [self performSegueWithIdentifier:@"goReadWithChapter" sender:sender];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
