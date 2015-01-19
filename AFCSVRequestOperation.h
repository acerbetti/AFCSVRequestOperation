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

#import "AFHTTPRequestOperation.h"

@interface AFCSVRequestOperation : AFHTTPRequestOperation

///----------------------------
/// @name Getting Response Data
///----------------------------

/**
 A CSV array constructed from the response data. If an error occurs while parsing, `nil` will be returned, and the `error` property will be set to the error.
 */
@property (readonly, nonatomic, strong) id responseCSV;


///----------------------------
/// @name Configure
///----------------------------

/**
 The delimiter character to be used when parsing the string. Must not be @c nil, and may not be the double quote character. Default is comma (',')
 */
@property (nonatomic, assign) unichar delimiter;

/**
 *  If @c YES, then the parser will removing surrounding double quotes and will unescape characters.
 *  The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL sanitizesFields;

/**
 *  If @c YES, then the parser will trim whitespace around fields. If @c sanitizesFields is also @c YES,
 *  then the sanitized field is also trimmed. The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL trimsWhitespace;

/**
 *  If @c YES, then the parser will allow special characters (delimiter, newline, quote, etc)
 *  to be escaped within a field using a backslash character. The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL recognizesBackslashesAsEscapes;

/**
 *  If @c YES, then the parser will interpret any field that begins with an octothorpe as a comment.
 *  Comments are terminated using an unescaped newline character. The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL recognizesComments;

/**
 *  If @c YES, then quoted fields may begin with an equal sign.
 *  Some programs produce fields with a leading equal sign to indicate that the contents must be represented exactly.
 *  The default value is @c NO.
 *  @warning Do not mutate this property after parsing has begun
 */
@property (nonatomic, assign) BOOL recognizesLeadingEqualSign;


///----------------------------------
/// @name Creating Request Operations
///----------------------------------

/**
 Creates and returns an `AFCSVRequestOperation` object and sets the specified success and failure callbacks.
 
 @param urlRequest The request object to be loaded asynchronously during execution of the operation
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the CSV array created from the response data of request.
 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data as CSV. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the error describing the network or parsing error that occurred.
 
 @return A new CSV request operation
 */
+ (instancetype)CSVRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id CSV))success
                                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id CSV))failure;

@end
