//
//  ACDashBoardCollectionViewCell.m
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ACDashBoardCollectionViewCell.h"

@interface ACDashBoardCollectionViewCell()

@end

@implementation ACDashBoardCollectionViewCell

-(void)setUpCell{
    
    [self.card_ImageView setImage:[UIImage imageNamed:@"reverse"]];
    [self setIsAvailable:YES];
    [self.card_ImageView.layer setBorderWidth:1.0];
    [self.card_ImageView.layer setBorderColor:[UIColor blackColor].CGColor];
}

@end
