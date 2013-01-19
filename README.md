AFCSVRequestOperation
=====================

AFCSVRequestOperation is an extension for [AFNetworking](http://github.com/AFNetworking/AFNetworking/) that provides an interface to parse CSV using [CHCSVParser](https://github.com/davedelong/CHCSVParser)


Example Usage
------------------

``` objective-c
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yourserver.com/yourfile.csv"]];
AFCSVRequestOperation *operation = [AFCSVRequestOperation CSVRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id CSV) {
  NSLog(@"CSV Data:\n%@", CSV);
} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id CSV) {
  NSLog(@"Failure!");
}];
    
[operation start];
```

License
------------------
Copyright (c) 2013 Stefano Acerbetti

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
