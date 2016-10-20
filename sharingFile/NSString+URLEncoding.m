#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
- (NSString*)URLEncodedString
{
  NSString *unreserved = @"-._~/?";
  NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                    alphanumericCharacterSet];
  [allowed addCharactersInString:unreserved];
  return [self
          stringByAddingPercentEncodingWithAllowedCharacters:
          allowed];
}

@end
