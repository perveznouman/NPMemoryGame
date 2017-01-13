//
//  ABCards.m
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ABCards.h"

@interface ABCards()
@end

@implementation ABCards

-(id)init{
    
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSUInteger)throughARandomCard :(NSArray *)availableCards{
    
    NSUInteger randomObject = arc4random() % [availableCards count];
    return randomObject;
}

@end
