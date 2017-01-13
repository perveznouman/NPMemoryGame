//
//  ABScore.h
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABScore : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSInteger scroe;
@property (strong, nonatomic) NSString *name;

-(void)updateCurrentScore :(NSInteger)points;
-(NSInteger)getCurrentScore;

@end
