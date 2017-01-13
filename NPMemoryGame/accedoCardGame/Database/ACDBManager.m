//
//  ACDBManager.m
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ACDBManager.h"
 
static ACDBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation ACDBManager{
    NSString *databasePath;
}

+(ACDBManager *)getsharedInstance{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths [0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"NPMemoryGame.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt = "create table if not exists scoreTable (playerID integer primary key AUTOINCREMENT, playerName TEXT, playerScore TEXT);";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            else{
                NSLog(@"table creaed");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else{
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL)addUserScore:(ABScore *)score{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"insert into scoreTable (playerName, playerScore) values (\"%@\", \"%ld\")", score.name, (long)score.scroe];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            return YES;
        }
        else{
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            return NO;
        }
    }
    return NO;
}

- (int)getHighScore{

    int highScore = 0;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *querySQL = @"SELECT MAX(playerScore) AS highest_score FROM scoreTable";
        const char *sqlStatement = [querySQL UTF8String];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK ) {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )  {
                highScore = sqlite3_column_int(statement, 0);
            }
        }
        else {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }

        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return highScore;
}

- (NSArray*)getAllScore {

    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {

        NSString *querySQL = [NSString stringWithFormat:@"select playerID, playerName, playerScore from scoreTable ORDER BY playerID"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                ABScore *score = [[ABScore alloc]init];

                const char *tmp1 = (const char*) sqlite3_column_text(statement, 0);
                const char *tmp2 = (const char*) sqlite3_column_text(statement, 1);
                const char *tmp3 = (const char*) sqlite3_column_text(statement, 2);
                if (tmp1 != NULL && tmp2 != NULL && tmp3 != NULL) {
                    NSString *pid = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                    NSString *pName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                    NSString *pScore = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                    
                    score.ID = [pid integerValue];
                    score.name = pName;
                    score.scroe = [pScore integerValue];
                    [resultArray addObject:score];
                }
            }
        }
    }
    return resultArray;
}


- (NSArray*)getCurrentPoistion {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat:@"select playerScore from scoreTable ORDER BY playerScore DESC"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                const char *tmp1 = (const char*) sqlite3_column_text(statement, 0);
                if (tmp1 != NULL ) {
                    NSString *pScore = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                    [resultArray addObject:pScore];
                }
            }
        }
    }
    return resultArray;
}

@end
