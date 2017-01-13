//
//  ACDBManager.h
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ABScore.h"

@interface ACDBManager : NSObject

+ (ACDBManager *)getsharedInstance;
- (BOOL)addUserScore:(ABScore *)score;
- (NSArray*)getCurrentPoistion;
- (NSArray*)getAllScore;
- (int)getHighScore;

@end
