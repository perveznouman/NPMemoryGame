//
//  ACDashBoardCollectionViewCell.h
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACDashBoardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *card_ImageView;
@property (strong, nonatomic) NSString *myCard;
@property (nonatomic) BOOL isAvailable;

-(void)setUpCell;
@end
