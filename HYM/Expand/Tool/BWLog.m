
#import "BWLog.h"

void printLog(NSString *file, int line, NSString *fmt, ...) 
{
    va_list ap;
    va_start(ap, fmt); 
    NSString *originalMessage = [[NSString alloc] initWithFormat:fmt arguments:ap] ;
    va_end(ap);  
       
    //格式化输出日志
    NSString * logOutputStr = [NSString stringWithFormat:@"%@:%d %@\n", file, line, originalMessage];
    
    //输出显示日志 
    NSLog(@"%@", logOutputStr);
}

