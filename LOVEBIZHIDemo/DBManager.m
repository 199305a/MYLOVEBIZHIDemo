//
//  DBManager.m
//  LimitFreeProject
//


#import "DBManager.h"
#import "FristModel.h"

//全局变量
NSString * const kLZXFavorite = @"favorites";
NSString * const kLZXDownloads = @"downloads";
NSString * const kLZXBrowses = @"browese";

/*
 数据库
 1.导入 libsqlite3.dylib
 2.导入 fmdb
 3.导入头文件
 fmdb 是对底层C语言的sqlite3的封装
 
 */
@implementation DBManager
{
    //数据库对象
    FMDatabase *_database;
}

+ (DBManager *)sharedManager {
    static DBManager *manager = nil;
    @synchronized(self) {//同步 执行 防止多线程操作
        if (manager == nil) {
            manager = [[DBManager alloc] init];
        }
    }
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        NSString *filePath = [self getFileFullPathWithFileName:@"app.db"];
        //2.创建database
        _database = [[FMDatabase alloc] initWithPath:filePath];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([_database open]) {
            NSLog(@"数据库打开成功");
            //创建表 不存在 则创建
            [self creatTable];
        }else {
            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark - 创建表
- (void)creatTable {
    //字段: 应用名 应用id 当前价格 最后价格 icon地址 记录类型 价格类型
    NSString *sql = @"create table if not exists appInfo(dataid integer  Primary Key Autoincrement,file_id Varchar(1024),group_id Varchar(1024),small Varchar(1024),big Varchar(1024),loved Varchar(1024),down Varchar(1024))";
    
    NSString *sql1 = @"create table if not exists tags(tagid integer  Primary Key Autoincrement,file_id Varchar(1024),name Varchar(1024),url Varchar(1024))";
    
    
    //创建表 如果不存在则创建新的表
    BOOL isSuccees = [_database executeUpdate:sql];
    if (!isSuccees) {
        NSLog(@"creatTable error---:%@",_database.lastErrorMessage);
    }
    
    BOOL isSuccees1 = [_database executeUpdate:sql1];
    if (!isSuccees1) {
        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
    }
}
#pragma mark - 获取文件的全路径

//获取文件在沙盒中的 Documents中的路径
- (NSString *)getFileFullPathWithFileName:(NSString *)fileName {
    NSString *docPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
   NSLog(@"%@",NSHomeDirectory());
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        //文件的全路径
        return [docPath stringByAppendingFormat:@"/%@",fileName];
    }else {
        //如果不存在可以创建一个新的
        NSLog(@"Documents不存在");
        return nil;
    }
}


//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model AppId:(NSString *)file_id{
    DataModel *datamodel = (DataModel *)model;
    if ([self isExistAppForAppId:datamodel.file_id]) {
        NSLog(@"this app has  recorded");
        return;
    }
    NSString *sql = @"insert into appInfo(file_id,group_id,small,big,loved,down) values (?,?,?,?,?,?)";
    BOOL isSuccess = [_database executeUpdate:sql,datamodel.file_id,datamodel.group_id,datamodel.image.small,datamodel.image.big,datamodel.counts.loved,datamodel.counts.down];
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
    
    for (TagsModel *modle in datamodel.tags) {
        NSString *sql1 = @"insert into tags(file_id,name,url) values (?,?,?)";
        BOOL isSuccess1 = [_database executeUpdate:sql1,datamodel.file_id,modle.name,modle.url];
        if (!isSuccess1) {
            NSLog(@"insert error:%@",_database.lastErrorMessage);
        }
        
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForAppId:(NSString *)appId {
    NSString *sql = @"delete from appInfo where file_id = ?";
    BOOL isSuccess = [_database executeUpdate:sql,appId];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}
//删除所有
- (void)deleteModelForAppId {
    NSString *sql = @"delete from appInfo";
    BOOL isSuccess = [_database executeUpdate:sql];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}


- (NSMutableArray *)tagsArray:(NSString *)fileID {
    NSString *sql = @"select * from tags where file_id = ?";
    FMResultSet *rs = [_database executeQuery:sql,fileID];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        TagsModel *tagsModel = [TagsModel new];
        tagsModel.name = [rs stringForColumn:@"name"];
        tagsModel.url = [rs stringForColumn:@"url"];
        [array addObject:tagsModel];
    }
    return array;

}
//根据指定类型  查找所有的记录
//根据记录类型 查找 指定的记录
- (NSArray *)readModels{
    
    NSString *sql = @"select * from appInfo";
    FMResultSet * rs = [_database executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        DataModel *appModel = [[DataModel alloc]init];
        appModel.file_id = [rs stringForColumn:@"file_id"];
        appModel.group_id = [rs stringForColumn:@"group_id"];
        appModel.imagesmall = [rs stringForColumn:@"small"];
        appModel.imagebig = [rs stringForColumn:@"big"];
        appModel.countsloved = [rs stringForColumn:@"loved"];
        appModel.countsdown = [rs stringForColumn:@"down"];
        appModel.tas1 = [self tagsArray:[rs stringForColumn:@"file_id"]];
        
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForAppId:(NSString *)appId{
    NSString *sql = @"select * from appInfo where file_id = ?";
    FMResultSet *rs = [_database executeQuery:sql,appId];
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
     //    NSLog(@"yes");
        return YES;
    }else{
     //   NSLog(@"no");
        return NO;
    }
}
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type {
    NSString *sql = @"select count(*) from appInfo where recordType = ?";
    FMResultSet *rs = [_database executeQuery:sql,type];
    NSInteger count = 0;
    while ([rs next]) {
        //查找 指定类型的记录条数
        count = [[rs stringForColumnIndex:0] integerValue];
    }
    return count;
}
- (NSInteger)getCountsFromApp {
    NSString *sql = @"select count(*) from appInfo";
    FMResultSet *rs = [_database executeQuery:sql];
    NSInteger count = 0;
    while ([rs next]) {
        //查找 指定类型的记录条数
        count = [[rs stringForColumnIndex:0] integerValue];
    }
    return count;
}


@end
