//
//  ACDashBoardCollectionViewController.m
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ACDashBoardCollectionViewController.h"
#import "ACDashBoardCollectionViewCell.h"
#import "ACDBManager.h"
#import "ABCards.h"
#import "ABScore.h"
#import "ACConstant.h"

@interface ACDashBoardCollectionViewController ()<UICollectionViewDelegateFlowLayout>{
    
    int tapCount;
    NSString *oddTappedCard;
    NSIndexPath *oddTappedIndexPath;
}

@property (strong, nonatomic) NSMutableArray *cardImages;
@property (strong, nonatomic) NSMutableArray *matchedCardImages;
@property (strong, nonatomic) ABCards *cards;
@property (strong, nonatomic) ABScore *score;

@end

@implementation ACDashBoardCollectionViewController
static NSString * const reuseIdentifier = @"Cell";

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.cards = [[ABCards alloc]init];
    self.cardImages = [NSMutableArray arrayWithObjects:@"cc",@"cloud",@"console",@"multiscreen",@"remote",@"tablet",@"tv",@"vr",@"cc",@"cloud",@"console",@"multiscreen",@"remote",@"tablet",@"tv",@"vr", nil];
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"Current Score : 0"];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:14 [UIColor whiteColor], NSForegroundColorAttributeName, nil]; [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:12.0f], NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attr];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIButton *barButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [barButton setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.score = [[ABScore alloc]init];
    self.matchedCardImages = [NSMutableArray new];
    tapCount = 0;
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"High Score :%d", [[ACDBManager getsharedInstance]getHighScore]];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame)/4-8, (CGRectGetHeight(self.collectionView.frame)/4)-20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellID";
    ACDashBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setUpCell];
    NSUInteger cardIndexToSet = [self.cards throughARandomCard:self.cardImages];
    [cell setMyCard:[self.cardImages objectAtIndex:cardIndexToSet]];
    [self.cardImages removeObjectAtIndex:cardIndexToSet];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ACDashBoardCollectionViewCell *cell = (ACDashBoardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath != oddTappedIndexPath) {
        if (cell.isAvailable) {
            [self availableCard:cell forIndexPath:indexPath];
        }
        else{
            [ACConstant showAlert:@"Card's matched already found" inViewController:self];
        }
    }
    else{
        [ACConstant showAlert:@"Select some other card" inViewController:self];
    }
}

#pragma mark - Private Method

-(void)availableCard :(ACDashBoardCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{

    [self setAnimations:cell];
    if (tapCount%2) {
        [self handleEvenTappedCards:cell];
    }
    else{
        [self handleOddTappedCards:cell forIndexPath:indexPath];
    }
    tapCount++;
}

-(void)handleOddTappedCards :(ACDashBoardCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    
    oddTappedIndexPath = indexPath;
    oddTappedCard = cell.myCard;
}

-(void)handleEvenTappedCards :(ACDashBoardCollectionViewCell *)cell{
    
    ACDashBoardCollectionViewCell *previousTappedCell = (ACDashBoardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:oddTappedIndexPath];
    if ([oddTappedCard isEqualToString:cell.myCard]) {
        [self handlingMatchingCards:cell andPreviousCell:previousTappedCell];
    }
    else{
        [self handleUnMatchedCards:cell andPreviousCell:previousTappedCell];
    }
    [self displayUpdatedScore];
}

-(void)handlingMatchingCards :(ACDashBoardCollectionViewCell *)currentCell andPreviousCell :(ACDashBoardCollectionViewCell *)previousCell{
    
    [currentCell setIsAvailable:NO];
    [previousCell setIsAvailable:NO];
    [self.matchedCardImages addObject:currentCell.myCard];
    [self.matchedCardImages addObject:previousCell.myCard];
    [self.score updateCurrentScore:5];
    if ([self.matchedCardImages count] == 16) {
        [self displayUserNameTextBoxAlert];
    }
}

-(void)handleUnMatchedCards :(ACDashBoardCollectionViewCell *)currentCell andPreviousCell :(ACDashBoardCollectionViewCell *)previousCell{
    
    [self.score updateCurrentScore:-1];
    [self.collectionView setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:currentCell cache:YES];
        [currentCell.card_ImageView setImage:[UIImage imageNamed:@"reverse"]];
        [previousCell.card_ImageView setImage:[UIImage imageNamed:@"reverse"]];
        [UIView commitAnimations];
        [self.collectionView setUserInteractionEnabled:YES];
    });
}

#pragma mark - Private Method Data

-(void)saveData :(NSString *)userName{
    
    self.score.scroe = [self.score getCurrentScore];
    self.score.name = userName;
    BOOL hasSaved = [[ACDBManager getsharedInstance]addUserScore:self.score];
    if (hasSaved) {
        NSArray *allScores  = [[ACDBManager getsharedInstance]getCurrentPoistion];
        NSInteger position = [allScores indexOfObject:[NSString stringWithFormat:@"%ld",self.score.scroe]];
        [ACConstant showAlert:[NSString stringWithFormat:@"Your current rank is %ld", (long)position+1] inViewController:self];
        [self restartGame];
    }
}

-(void)restartGame{
    
    self.cardImages = [NSMutableArray arrayWithObjects:@"cc",@"cloud",@"console",@"multiscreen",@"remote",@"tablet",@"tv",@"vr",@"cc",@"cloud",@"console",@"multiscreen",@"remote",@"tablet",@"tv",@"vr", nil];
    [self.matchedCardImages removeAllObjects];
    [self.collectionView reloadData];
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"Current Score : 0"];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"High Score :%d", [[ACDBManager getsharedInstance]getHighScore]];
}

#pragma mark - Private Method Display

-(void)displayUpdatedScore{
    
    oddTappedIndexPath = nil;
    oddTappedCard = @"";
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"Current Score : %ld", (long)[self.score getCurrentScore]];
}

-(void)setAnimations :(ACDashBoardCollectionViewCell *)cell{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell cache:YES];
    [cell.card_ImageView setImage:[UIImage imageNamed:cell.myCard]];
    [UIView commitAnimations];
}


-(void)displayUserNameTextBoxAlert {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save"
                                  message:@"Enter Player's Name"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [self saveData:alert.textFields.firstObject.text];
                                               }];
    [alert addAction:ok];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Player Name";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

@end




