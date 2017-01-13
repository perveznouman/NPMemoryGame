//
//  ABScore.m
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ABScore.h"

@interface ABScore()
@property (nonatomic) NSInteger currentScrore;
@end

@implementation ABScore

-(id)init{
    
    self = [super init];
    if (self) {
        self.currentScrore = 0;
    }
    return self;
}

-(void)updateCurrentScore :(NSInteger)points{
    self.currentScrore = self.currentScrore + points;
//    NSLog(@"CurrentScore %ld", (long)self.currentScrore);
}

-(NSInteger)getCurrentScore{
    return self.currentScrore;
}

@end
