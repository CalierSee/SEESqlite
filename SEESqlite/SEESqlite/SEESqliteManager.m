//
//  SEESqliteManager.m
//  SEESqlite
//
//  Created by 三只鸟 on 2017/9/22.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEESqliteManager.h"
#import <objc/runtime.h>
#import <sqlite3.h>

@implementation SEESqliteManager {
    //标识
    sqlite3 * _ppDb;
    //文件名
    NSString * _fileName;
    //文件类型
    NSString * _type;
    //数据库中的表
    NSMutableDictionary * _tableCache;
    
    
}

/**
 单利

 @return 对象
 */
+ (instancetype)manager {
    static SEESqliteManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        //打开数据库
        NSAssert(!sqlite3_open([manager see_path], &(manager -> _ppDb)),@"数据库打开失败 %s",[manager see_path]);
        
    });
    return manager;
}

//============创建数据表===========//

/**
 <#Description#>

 @param table <#table description#>
 @param obj <#obj description#>
 */
- (void)see_createTable:(NSString *)table withObj:(id)obj {
    
}




//============end===========//


//返回数据库路径
- (const char *)see_path {
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    if (_fileName) {
        NSString * lastPath = _fileName;
        if (_type) {
            lastPath = [lastPath stringByAppendingFormat:@".%@",_type];
        }
        path = [path stringByAppendingPathComponent:lastPath];
    }
    else {
        path = [path stringByAppendingPathComponent:@"see_sqlite.db"];
    }
    return path.UTF8String;
}

@end
