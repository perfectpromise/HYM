/*
 在预编译头文件中加入Log.h头文件,在整个项目中,需要打印日志的地方,使用BWLog代替系统自带的NSLog
 打印出来的日志,包含了类名、类中所在行数、以及需要打印的信息
 如:AppDelegate.m:33 BWLog Test
 */
#import <Foundation/Foundation.h>

#define DEBUG_FILE                    ([[[NSString alloc] initWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent])
#define DEBUG_LINE                    (__LINE__)


#ifdef __cplusplus
extern "C"
{
#endif
void printLog(NSString *file, int line, NSString *fmt, ...);
#ifdef __cplusplus
}
#endif

#if DEBUG
    #define BWLog(fmt, ...)  printLog(DEBUG_FILE, DEBUG_LINE, fmt, ##__VA_ARGS__);
#else
    #define BWLog(fmt, ...)  @"";
#endif


