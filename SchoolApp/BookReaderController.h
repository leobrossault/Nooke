//
//  BookReaderController.h
//  SchoolApp
//
//  Created by Léo Brossault on 31/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Pupils.h"
#import "Book.h"
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)


@interface BookReaderController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    int index;
    int indexTypo;
    int indexDrag;
    int rowSelected;
    int goodAnswersNb;
    int step;
    int nbTry;
    BOOL showHide;
    BOOL showHideInfos;
    BOOL readFinish;
    BOOL activityStarted;
    BOOL activityFinish;
    BOOL activityInProgress;
    BOOL tapProgressBtn;
    BOOL deployMenuActiv;
    BOOL rotation;
    BOOL drag1;
    BOOL drag2;
    BOOL drag3;
    BOOL drag4;
    //CGRect textFrame;
    CGRect barFrame;
    CGRect bottomFrame;
}

@property(nonatomic) Pupils *myPupil;
@property (nonatomic, strong) Book *myBook;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) UITextView *chapterText;

/* PROGRESS BAR */
@property (nonatomic, strong) UIView *bar;

/* MESSAGES */
@property (strong, nonatomic) NSArray *messages;

/* ZONE INFOS */
@property (nonatomic, strong) UIView *infos;
@property (nonatomic, strong) UILabel *selectedWord;
@property (nonatomic, strong) UIButton *btnWordBag;
@property (nonatomic, strong) UILabel *popupWordBag;
@property (nonatomic, strong) UILabel *plusUn;
@property (nonatomic, strong) UIButton *btnVikidia;
@property (nonatomic, strong) UIButton *btnMessageInfos;
@property (nonatomic, strong) UIButton *closeInfos;
@property (nonatomic, strong) UITextView *defWord;
@property (strong, nonatomic) UIPopoverController *popupZoneInfo;
@property (strong, nonatomic) NSMutableArray *arrayClone;

/* BOTTOM VIEW */
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *sentenceBottom;
@property (strong, nonatomic) UIImageView *imageViewBottom;
@property (strong, nonatomic) UIImage *icoCheck;
@property (strong, nonatomic) UILabel *sentenceBisBottom;

/* ACTIVITY */
@property (strong, nonatomic) UIView *activity;
@property (strong, nonatomic) UIImageView *imageViewNumQuestion1;
@property (strong, nonatomic) UIImage *numQuestion1Ico;
@property (strong, nonatomic) UIImageView *imageViewNumQuestion2;
@property (strong, nonatomic) UIImage *numQuestion2Ico;
@property (strong, nonatomic) UIImageView *imageViewNumQuestion3;
@property (strong, nonatomic) UIImage *numQuestion3Ico;
@property (nonatomic, strong) UIButton *nextQuestion;
@property (strong, nonatomic) UIView *containerOrder;
@property (strong, nonatomic) UILabel *order;

/* FIRST ACTIVITY */
/* firstQuestion */
@property (nonatomic, strong) UIView *word1;
@property (nonatomic, strong) UIView *word2;
@property (nonatomic, strong) UIView *word3;
@property (nonatomic, strong) UIView *word4;
@property (strong, nonatomic) UILabel *dragWord;
@property (nonatomic, strong) UILabel *answer1;
@property (nonatomic, strong) UILabel *answer2;
@property (nonatomic, strong) UILabel *answer3;
@property (nonatomic, strong) UILabel *answer4;
@property (strong, nonatomic) NSArray *goodAnswers;

/* second question */
@property (nonatomic, strong) UILabel *choice1;
@property (nonatomic, strong) UILabel *choice2;
@property (nonatomic, strong) UILabel *choice3;
@property (nonatomic, strong) UILabel *choice4;
@property (nonatomic, strong) UILabel *selected;

/* third question */
@property (strong, nonatomic) NSArray *pickerData;

/* FINISH ACTIVITY */
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, strong) UILabel *titleFinishView;
@property (nonatomic, strong) UILabel *textFinishView;
@property (nonatomic, strong) UIButton *reloadActivity;
@property (nonatomic, strong) UIButton *finishActivity;

@end
