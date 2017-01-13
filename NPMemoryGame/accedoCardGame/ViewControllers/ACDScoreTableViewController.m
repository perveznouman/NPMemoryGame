//
//  ACDScoreTableViewController.m
//  accedoCardGame
//
//  Created by Nouman on 09/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ACDScoreTableViewController.h"
#import "ACDBManager.h"
#import "ABScore.h"

@interface ACDScoreTableViewController ()
@property (strong, nonatomic) NSArray *allScore;
@property (strong, nonatomic) ABScore *score;

@end

@implementation ACDScoreTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.allScore = [[ACDBManager getsharedInstance]getAllScore];
    self.score = [ABScore new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allScore count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scoreCell" forIndexPath:indexPath];
    self.score = [self.allScore objectAtIndex:[indexPath row]];
    [cell.textLabel setText:self.score.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)self.score.scroe]];
    return cell;
}



@end
