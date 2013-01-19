/*
 * AFCSVRequestOperation: https://github.com/acerbetti/AFCSVRequestOperation
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "AFCSVRequestOperation.h"
#import "CHCSVParser.h"

static dispatch_queue_t af_csv_request_operation_processing_queue;
static dispatch_queue_t csv_request_operation_processing_queue() {
    if (af_csv_request_operation_processing_queue == NULL) {
        af_csv_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.csv-request.processing", 0);
    }
    
    return af_csv_request_operation_processing_queue;
}


@interface AFCSVRequestOperation ()<CHCSVParserDelegate>
@property (readwrite, nonatomic, strong) id responseCSV;
@property (readwrite, nonatomic, strong) NSMutableArray *currentLine;
@property (readwrite, nonatomic, strong) NSError *CSVError;
@end


@implementation AFCSVRequestOperation

+ (instancetype)CSVRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id CSV))success
                                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id CSV))failure
{
    AFCSVRequestOperation *requestOperation = [(AFCSVRequestOperation *)[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(AFCSVRequestOperation *)operation responseCSV]);
        }
    }];
    
    return requestOperation;
}


- (id)responseCSV
{
    if (!_responseCSV && [self.responseData length] > 0 && [self isFinished] && !self.CSVError) {
        NSError *error = nil;
        
        // use the lib to parse the data
        CHCSVParser *parser = [[CHCSVParser alloc] initWithCSVString:self.responseString];
        parser.delegate = self;
        [parser parse];
        
        self.CSVError = error;
    }
    
    return _responseCSV;
}


#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes
{
    return [NSSet setWithObjects:@"text/csv", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"csv"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.completionBlock = ^ {
        if ([self isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        } else {
            dispatch_async(csv_request_operation_processing_queue(), ^{
                NSArray *CSVdata = self.responseCSV;
                
                if (self.CSVError) {
                    if (failure) {
                        dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                            failure(self, self.error);
                        });
                    }
                } else {
                    if (success) {
                        dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                            success(self, CSVdata);
                        });
                    }
                }
            });
        }
    };
#pragma clang diagnostic pop
}


#pragma mark - CHCSVParserDelegate

- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    self.responseCSV = [NSMutableArray new];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    self.currentLine = [NSMutableArray new];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    [self.responseCSV addObject:self.currentLine];
    self.currentLine = nil;
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    [self.currentLine addObject:field];
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    self.responseCSV = nil;
    self.CSVError = error;
}

@end
