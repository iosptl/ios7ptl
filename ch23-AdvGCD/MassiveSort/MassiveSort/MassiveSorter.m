//
//  MassiveSorter.m
//  MassiveSort
//
//  Created by Rob Napier on 9/29/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "MassiveSorter.h"

@implementation MassiveSorter

/* Creates a file with two 32-bit fields:
 *   Record number (monotonically increasing)
 *   Value (random)
 */
//- (void)generateRandomFileAtPath:(NSString *)path count:(long)count handler:(MassiveSorterHandler)handler {
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSLog(@"generateRandomFile:start");
//    FILE *file = fopen([path UTF8String], "w");
//    NSAssert(file, @"Could not open file:%@", path);
//
//    dispatch_source_t progressSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
//    __block uint32_t totalComplete = 0;
//    dispatch_source_set_event_handler(progressSource, ^{
//      unsigned long value = dispatch_source_get_data(progressSource);
//      totalComplete += value;
//      handler((CGFloat)totalComplete/count,
//              (totalComplete >= count));
//    });
//    dispatch_resume(progressSource);
//
//    for (uint32_t i = 0; i < count; ++i) {
//      @autoreleasepool {
//        uint32_t value = arc4random();
//        fwrite(&i, sizeof(i), 1, file);
//        fwrite(&value, sizeof(value), 1, file);
//        dispatch_source_merge_data(progressSource, 1);
//      }
//    }
//    fclose(file);
//    NSLog(@"generateRandomFile:done");
//  });
//}

- (void)generateRandomFileAtPath:(NSString *)path count:(long)count handler:(MassiveSorterHandler)handler {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"generateRandomFile:start");
    dispatch_queue_t writeQueue = dispatch_queue_create("MassiveSorter.write", DISPATCH_QUEUE_SERIAL);
    dispatch_io_t fileHandler = dispatch_io_create_with_path(DISPATCH_IO_STREAM, [path UTF8String], O_WRONLY|O_CREAT, S_IRWXU, writeQueue, nil);

    dispatch_source_t progressSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    __block uint32_t totalComplete = 0;
    dispatch_source_set_event_handler(progressSource, ^{
      unsigned long value = dispatch_source_get_data(progressSource);
      totalComplete += value;
      handler((CGFloat)totalComplete/count,
              (totalComplete >= count));
    });
    dispatch_resume(progressSource);

    for (uint32_t i = 0; i < count; ++i) {
      @autoreleasepool {
        uint32_t values[2] = {i, arc4random()};
        dispatch_data_t data = dispatch_data_create(values, 2 *sizeof(*values), dispatch_get_main_queue(), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
        dispatch_io_write(fileHandler, 0, data, writeQueue,^(bool done, dispatch_data_t data, int error) {});
        dispatch_source_merge_data(progressSource, 1);
      }
    }
    dispatch_io_close(fileHandler, 0);
    NSLog(@"generateRandomFile:done");
  });
}

- (void)sortFileAtPath:(NSString *)path {

}

- (void)printNumbersAtPath:(NSString *)path {
  FILE *file = fopen([path UTF8String], "r");
  NSAssert(file, @"Could not open file:%@", path);

  uint32_t values[2];
  while (fread(&values, sizeof(uint32_t), 2, file) > 0) {
    printf("%u:%u\n", values[0], values[1]);
  }
  fclose(file);
}

@end
