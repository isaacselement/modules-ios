#import "RSAKeysKeeper.h"

/**
 *
 *
 
 // For security sake , not put .p12 and .der in your resouce bundle, just keep their base64 result in codes
 
 //    NSString* privateKeyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
 //    NSString* p12String = [[[NSData alloc] initWithContentsOfFile:privateKeyPath] base64EncodedString];
 //    NSLog(@"p12 string : %@", p12String);
 
 //    NSString* publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
 //    NSString* derString = [[[NSData alloc] initWithContentsOfFile:publicKeyPath] base64EncodedString];
 //    NSLog(@"der string : %@", derString);
 
 
 (1)
 fist just import the two key file in your project, got their base64 string, then remove them from your project:
 
 NSData* dataP12 = [NSData dataWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"private_key.p12" ]];
 NSString* base64StringP12 = [dataP12 base64EncodedString ];
 NSLog(@"p12 string : %@", base64StringP12);
 
 
 NSData* dataDer = [NSData dataWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"public_key.der"]];
 NSString* base64StringDer = [dataDer base64EncodedString ];
 NSLog(@"p12 string : %@", base64StringDer);
 
 
 (2)
 or just use command line issue:
 
 cd [Path_To_Keys];
 base64 private_key.p12;
 base64 public_key.der;
 
 *
 *
 **/




/**
 
 p12:
 (1)
 MIIGWQIBAzCCBh8GCSqGSIb3DQEHAaCCBhAEggYMMIIGCDCCAwcGCSqGSIb3DQEH
 BqCCAvgwggL0AgEAMIIC7QYJKoZIhvcNAQcBMBwGCiqGSIb3DQEMAQYwDgQIouek
 DX/jqZsCAggAgIICwMhw6N4byoX6sVHS9m7YiWa/TxzLEL/DoyhRf9xlI+D2ibxN
 ukfjfwFbYQySFAJnVnwUSlbYh1mMLtpcIWLfgAVcOHkA8VmkFg30IiOE6syDM049
 i3WQFzIXgRH0ET0FJ+J8PeakJr4VnA8USPT1dRCaHCgnP3oeyjzwcEpYkarGtynk
 45tlH/2xDaL7TPeiTf5VjHuFjRbR+ePqAm/bydAZg6FlhGUV8ZK0h7qGFFdFDN67
 8aTsKRKZXkpDraeberNCxkpYovWrsT9uWEOmZytYm6WeMj8eXl1Ac3rLqUBeTB7F
 fVDrJ5awkwNLhxKJ+jD0L0KMkSLqtNughOLZ7oFNxi9Ga5ms/VhQc8+B1fmP6GFr
 pd+j1yEgoajHjjlRGVGn/zevxwUPIvGPz7wfHo+C8vJPRuvQ0bFkBcNn/kLII2Pm
 b8N8Su5BXrRPmVJzUMUUgauIWEkiWZ0LrcafPiV21KFcVE7D9BZoC1x0V5+EPH2c
 o6DbxOSxwuiuIIBJX/FBt8jTSQWfo9xmTzUN3H8UJXKF61a8W1dI/ETVkhyhGu/N
 Ipan14Y62Zq7a2+l3Z7uDcg9CAHVsgjuV7j1SRd0sciFS/z/jq6rKxTSGoKrR/NN
 Fb/wbHSfWBGl3swhpYR/+mi4tCo1P2uTB4tvN3MUzRwOE7DahFl3pmoYXs0guzse
 NNaGsm03eeGKfOpH/Ld1FJKzVxhZdxHOkgPQAwvxcfbdbQ2DshoLqa+GsqdKzAqK
 6+VblUpHeoD06d/ZvMotYi4i+GETdR0YZIicM6t98pTPiN2ULhuwIOnnTEfz3xl5
 ZGHhtvb84kUiTsjwU18nsK5u4qa6XLz5EAkSbpxE3tnWxKcYN2jd2vOzeR/gZ2as
 Zb8V43n9D1Yjbo8s6b0lo1CQ6+1vbf8eO/e8sf7aD/7r7rf9AxJxvtvg5ylsMIIC
 +QYJKoZIhvcNAQcBoIIC6gSCAuYwggLiMIIC3gYLKoZIhvcNAQwKAQKgggKmMIIC
 ojAcBgoqhkiG9w0BDAEDMA4ECA8FRTbqH2YxAgIIAASCAoALZIQj5lGJ9mK2arRA
 igFRT9+1UJu8homkgA3LQmsa4caXccLNRF1UkYBUk9vjgwZPEMkJJTNWNi8bMgng
 UkzT+LLYRi06OhkLx4QBXcF21lfg1D3iyBwkJXXA0eZ+4sbD6EDgnFFkkVq4qj5x
 oJtr3QbTvypUoaeWunsoJheZAYWL0OTk2CfURfsj/wBeYUaSk7zHMT01l5+IpypE
 C/vxP3aYBpk7CyO/52TCDeB4c+LKnSHUXqmdyvD9yUeKMe//lSwz6ghkgkOqAHt6
 dSFwaR878ErrDRFzCIZX5VoW/ofLgy56oFKEpelDUK16qiTgp2As+QokTgrO061w
 MHE3LngS2Mhjos5NndXFJH3iZI1PrFhQ1DkTJrnDVnvKDl1mqAM7Jsb5FbzgE+8a
 JmGzPNJji3NpSnWQEXmFuZqhScACmwvEU30eQJ6eo9JvgcNpfjVocKwbJc2ghQlN
 cqBooNHye9XiVcgHzLvNtW0tpnAf9ViS4ctSalRirFJwZVAtfauvWdbMHpOHMPv+
 Ro0fiCYmJ/yWXRrFKzbUygkROc8Y2e1QO5rTiuhXFDoQ3fkbb9JZ+mvYrKsEE+9z
 fU8hXM+8ScVXZow0e2iKdMgrHM1u8PwQfbHef5f1UvX3FvbLVSN3y0GoNK96L5jq
 lnjvUilloK0LyO6wti8JNa7kQItceHZmczPRnwwPJbkg9T2m5Cqm1LmkKob4Luay
 ghwNCyBfszOjDWNoflpU+uK1YZecBj7O1kygrLpbtz6Z9tyKwu5i27/yndPX3kYN
 Iz4v71nOYyUxl0LWl73bKthLMzFguRnpjmpCuX5/4YhzDanNXL0cXoruV49BCfuA
 TxxyMSUwIwYJKoZIhvcNAQkVMRYEFFfDIHdGqv40JGS+zx4ySAjhwG6YMDEwITAJ
 BgUrDgMCGgUABBRdFhfanDlwtVBsn5qXVHj3c8J5ZwQIyqccZBoAeRUCAggA
 
 (2)
 MIIGWQIBAzCCBh8GCSqGSIb3DQEHAaCCBhAEggYMMIIGCDCCAwcGCSqGSIb3DQEHBqCCAvgwggL0AgEAMIIC7QYJKoZIhvcNAQcBMBwGCiqGSIb3DQEMAQYwDgQIouekDX/jqZsCAggAgIICwMhw6N4byoX6sVHS9m7YiWa/TxzLEL/DoyhRf9xlI+D2ibxNukfjfwFbYQySFAJnVnwUSlbYh1mMLtpcIWLfgAVcOHkA8VmkFg30IiOE6syDM049i3WQFzIXgRH0ET0FJ+J8PeakJr4VnA8USPT1dRCaHCgnP3oeyjzwcEpYkarGtynk45tlH/2xDaL7TPeiTf5VjHuFjRbR+ePqAm/bydAZg6FlhGUV8ZK0h7qGFFdFDN678aTsKRKZXkpDraeberNCxkpYovWrsT9uWEOmZytYm6WeMj8eXl1Ac3rLqUBeTB7FfVDrJ5awkwNLhxKJ+jD0L0KMkSLqtNughOLZ7oFNxi9Ga5ms/VhQc8+B1fmP6GFrpd+j1yEgoajHjjlRGVGn/zevxwUPIvGPz7wfHo+C8vJPRuvQ0bFkBcNn/kLII2Pmb8N8Su5BXrRPmVJzUMUUgauIWEkiWZ0LrcafPiV21KFcVE7D9BZoC1x0V5+EPH2co6DbxOSxwuiuIIBJX/FBt8jTSQWfo9xmTzUN3H8UJXKF61a8W1dI/ETVkhyhGu/NIpan14Y62Zq7a2+l3Z7uDcg9CAHVsgjuV7j1SRd0sciFS/z/jq6rKxTSGoKrR/NNFb/wbHSfWBGl3swhpYR/+mi4tCo1P2uTB4tvN3MUzRwOE7DahFl3pmoYXs0guzseNNaGsm03eeGKfOpH/Ld1FJKzVxhZdxHOkgPQAwvxcfbdbQ2DshoLqa+GsqdKzAqK6+VblUpHeoD06d/ZvMotYi4i+GETdR0YZIicM6t98pTPiN2ULhuwIOnnTEfz3xl5ZGHhtvb84kUiTsjwU18nsK5u4qa6XLz5EAkSbpxE3tnWxKcYN2jd2vOzeR/gZ2asZb8V43n9D1Yjbo8s6b0lo1CQ6+1vbf8eO/e8sf7aD/7r7rf9AxJxvtvg5ylsMIIC+QYJKoZIhvcNAQcBoIIC6gSCAuYwggLiMIIC3gYLKoZIhvcNAQwKAQKgggKmMIICojAcBgoqhkiG9w0BDAEDMA4ECA8FRTbqH2YxAgIIAASCAoALZIQj5lGJ9mK2arRAigFRT9+1UJu8homkgA3LQmsa4caXccLNRF1UkYBUk9vjgwZPEMkJJTNWNi8bMgngUkzT+LLYRi06OhkLx4QBXcF21lfg1D3iyBwkJXXA0eZ+4sbD6EDgnFFkkVq4qj5xoJtr3QbTvypUoaeWunsoJheZAYWL0OTk2CfURfsj/wBeYUaSk7zHMT01l5+IpypEC/vxP3aYBpk7CyO/52TCDeB4c+LKnSHUXqmdyvD9yUeKMe//lSwz6ghkgkOqAHt6dSFwaR878ErrDRFzCIZX5VoW/ofLgy56oFKEpelDUK16qiTgp2As+QokTgrO061wMHE3LngS2Mhjos5NndXFJH3iZI1PrFhQ1DkTJrnDVnvKDl1mqAM7Jsb5FbzgE+8aJmGzPNJji3NpSnWQEXmFuZqhScACmwvEU30eQJ6eo9JvgcNpfjVocKwbJc2ghQlNcqBooNHye9XiVcgHzLvNtW0tpnAf9ViS4ctSalRirFJwZVAtfauvWdbMHpOHMPv+Ro0fiCYmJ/yWXRrFKzbUygkROc8Y2e1QO5rTiuhXFDoQ3fkbb9JZ+mvYrKsEE+9zfU8hXM+8ScVXZow0e2iKdMgrHM1u8PwQfbHef5f1UvX3FvbLVSN3y0GoNK96L5jqlnjvUilloK0LyO6wti8JNa7kQItceHZmczPRnwwPJbkg9T2m5Cqm1LmkKob4LuayghwNCyBfszOjDWNoflpU+uK1YZecBj7O1kygrLpbtz6Z9tyKwu5i27/yndPX3kYNIz4v71nOYyUxl0LWl73bKthLMzFguRnpjmpCuX5/4YhzDanNXL0cXoruV49BCfuATxxyMSUwIwYJKoZIhvcNAQkVMRYEFFfDIHdGqv40JGS+zx4ySAjhwG6YMDEwITAJBgUrDgMCGgUABBRdFhfanDlwtVBsn5qXVHj3c8J5ZwQIyqccZBoAeRUCAggA
 
 
 der:
 (1)
 MIICXTCCAcYCCQCz/8FZNpNjZzANBgkqhkiG9w0BAQUFADBzMQswCQYDVQQGEwJD
 TjELMAkGA1UECBMCR0QxCzAJBgNVBAcTAkdaMQswCQYDVQQKEwJHWjELMAkGA1UE
 CxMCR1oxDzANBgNVBAMTBklTQUFDUzEfMB0GCSqGSIb3DQEJARYQNTUxNzM2OTEz
 QFFRLkNPTTAeFw0xNDA2MjEwMjM2MDFaFw0yNDA2MTgwMjM2MDFaMHMxCzAJBgNV
 BAYTAkNOMQswCQYDVQQIEwJHRDELMAkGA1UEBxMCR1oxCzAJBgNVBAoTAkdaMQsw
 CQYDVQQLEwJHWjEPMA0GA1UEAxMGSVNBQUNTMR8wHQYJKoZIhvcNAQkBFhA1NTE3
 MzY5MTNAUVEuQ09NMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCeb4zRZnru
 PoX0tzbF41HEuZ56Oyx7DkHKYfgpu4Oo4CrhBZy+im5vGad997A4cE0bqjytgO6K
 Cy5N/PDit75msNfgiUB2UXtzAuc6vSh+5aSF7xqMOserCqxIfx9uU6eItuRbFD7F
 lyR7zNUcSmgbCf4xFE7qoIK1PmYWHGF6RwIDAQABMA0GCSqGSIb3DQEBBQUAA4GB
 AB03NVXiHANxx+1ejAnoF+v5T7IKS/KmWTkOzmrggXX7Yys4mJr/wpxBGhn9F0XY
 ZqSKG9igqGYHsEKO6s6eem2SnO5ILN0EFWpONu3hbytjtWHSUVyyo06qJiS6PYOE
 uYWWptD3PqLdDUOVQsOjibkthB9qHAhAU7In64Hgg4yh
 
 (2)
 MIICXTCCAcYCCQCz/8FZNpNjZzANBgkqhkiG9w0BAQUFADBzMQswCQYDVQQGEwJDTjELMAkGA1UECBMCR0QxCzAJBgNVBAcTAkdaMQswCQYDVQQKEwJHWjELMAkGA1UECxMCR1oxDzANBgNVBAMTBklTQUFDUzEfMB0GCSqGSIb3DQEJARYQNTUxNzM2OTEzQFFRLkNPTTAeFw0xNDA2MjEwMjM2MDFaFw0yNDA2MTgwMjM2MDFaMHMxCzAJBgNVBAYTAkNOMQswCQYDVQQIEwJHRDELMAkGA1UEBxMCR1oxCzAJBgNVBAoTAkdaMQswCQYDVQQLEwJHWjEPMA0GA1UEAxMGSVNBQUNTMR8wHQYJKoZIhvcNAQkBFhA1NTE3MzY5MTNAUVEuQ09NMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCeb4zRZnruPoX0tzbF41HEuZ56Oyx7DkHKYfgpu4Oo4CrhBZy+im5vGad997A4cE0bqjytgO6KCy5N/PDit75msNfgiUB2UXtzAuc6vSh+5aSF7xqMOserCqxIfx9uU6eItuRbFD7FlyR7zNUcSmgbCf4xFE7qoIK1PmYWHGF6RwIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAB03NVXiHANxx+1ejAnoF+v5T7IKS/KmWTkOzmrggXX7Yys4mJr/wpxBGhn9F0XYZqSKG9igqGYHsEKO6s6eem2SnO5ILN0EFWpONu3hbytjtWHSUVyyo06qJiS6PYOEuYWWptD3PqLdDUOVQsOjibkthB9qHAhAU7In64Hgg4yh
 
 **/



@implementation RSAKeysKeeper

static NSString* _derKey = nil;
static NSString* _p12Key = nil;
static NSString* _p12Password = nil;


+(NSString*) derKey
{
    if (! _derKey) {
        
        NSMutableString* derformat = [[NSMutableString alloc] init];
        for (int i = 0; i < 12; i++) {
            [derformat appendString: @"%@\r"];
        }
        [derformat appendString: @"%@"];
        
        NSString* derBase64String = [NSString stringWithFormat:derformat,
                                     @"MIICXTCCAcYCCQCz/8FZNpNjZzANBgkqhkiG9w0BAQUFADBzMQswCQYDVQQGEwJD",
                                     @"TjELMAkGA1UECBMCR0QxCzAJBgNVBAcTAkdaMQswCQYDVQQKEwJHWjELMAkGA1UE",
                                     @"CxMCR1oxDzANBgNVBAMTBklTQUFDUzEfMB0GCSqGSIb3DQEJARYQNTUxNzM2OTEz",
                                     @"QFFRLkNPTTAeFw0xNDA2MjEwMjM2MDFaFw0yNDA2MTgwMjM2MDFaMHMxCzAJBgNV",
                                     @"BAYTAkNOMQswCQYDVQQIEwJHRDELMAkGA1UEBxMCR1oxCzAJBgNVBAoTAkdaMQsw",
                                     @"CQYDVQQLEwJHWjEPMA0GA1UEAxMGSVNBQUNTMR8wHQYJKoZIhvcNAQkBFhA1NTE3",
                                     @"MzY5MTNAUVEuQ09NMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCeb4zRZnru",
                                     @"PoX0tzbF41HEuZ56Oyx7DkHKYfgpu4Oo4CrhBZy+im5vGad997A4cE0bqjytgO6K",
                                     @"Cy5N/PDit75msNfgiUB2UXtzAuc6vSh+5aSF7xqMOserCqxIfx9uU6eItuRbFD7F",
                                     @"lyR7zNUcSmgbCf4xFE7qoIK1PmYWHGF6RwIDAQABMA0GCSqGSIb3DQEBBQUAA4GB",
                                     @"AB03NVXiHANxx+1ejAnoF+v5T7IKS/KmWTkOzmrggXX7Yys4mJr/wpxBGhn9F0XY",
                                     @"ZqSKG9igqGYHsEKO6s6eem2SnO5ILN0EFWpONu3hbytjtWHSUVyyo06qJiS6PYOE",
                                     @"uYWWptD3PqLdDUOVQsOjibkthB9qHAhAU7In64Hgg4yh"
                                     ];
        
        
        _derKey = derBase64String;
        
        // or
        
//        _derKey = @" MIICXTCCAcYCCQCz/8FZNpNjZzANBgkqhkiG9w0BAQUFADBzMQswCQYDVQQGEwJDTjELMAkGA1UECBMCR0QxCzAJBgNVBAcTAkdaMQswCQYDVQQKEwJHWjELMAkGA1UECxMCR1oxDzANBgNVBAMTBklTQUFDUzEfMB0GCSqGSIb3DQEJARYQNTUxNzM2OTEzQFFRLkNPTTAeFw0xNDA2MjEwMjM2MDFaFw0yNDA2MTgwMjM2MDFaMHMxCzAJBgNVBAYTAkNOMQswCQYDVQQIEwJHRDELMAkGA1UEBxMCR1oxCzAJBgNVBAoTAkdaMQswCQYDVQQLEwJHWjEPMA0GA1UEAxMGSVNBQUNTMR8wHQYJKoZIhvcNAQkBFhA1NTE3MzY5MTNAUVEuQ09NMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCeb4zRZnruPoX0tzbF41HEuZ56Oyx7DkHKYfgpu4Oo4CrhBZy+im5vGad997A4cE0bqjytgO6KCy5N/PDit75msNfgiUB2UXtzAuc6vSh+5aSF7xqMOserCqxIfx9uU6eItuRbFD7FlyR7zNUcSmgbCf4xFE7qoIK1PmYWHGF6RwIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAB03NVXiHANxx+1ejAnoF+v5T7IKS/KmWTkOzmrggXX7Yys4mJr/wpxBGhn9F0XYZqSKG9igqGYHsEKO6s6eem2SnO5ILN0EFWpONu3hbytjtWHSUVyyo06qJiS6PYOEuYWWptD3PqLdDUOVQsOjibkthB9qHAhAU7In64Hgg4yh";
    }
    return _derKey;
}


+(NSString*) p12Key
{
    if (!_p12Key) {
        NSMutableString* p12format = [[NSMutableString alloc] init];
        for (int i = 0; i < 33; i++) {
            [p12format appendString: @"%@\r"];
        }
        [p12format appendString: @"%@"];
        
        NSString* p12Base64String = [NSString stringWithFormat:p12format,
                                     @"MIIGWQIBAzCCBh8GCSqGSIb3DQEHAaCCBhAEggYMMIIGCDCCAwcGCSqGSIb3DQEH",
                                     @"BqCCAvgwggL0AgEAMIIC7QYJKoZIhvcNAQcBMBwGCiqGSIb3DQEMAQYwDgQIouek",
                                     @"DX/jqZsCAggAgIICwMhw6N4byoX6sVHS9m7YiWa/TxzLEL/DoyhRf9xlI+D2ibxN",
                                     @"ukfjfwFbYQySFAJnVnwUSlbYh1mMLtpcIWLfgAVcOHkA8VmkFg30IiOE6syDM049",
                                     @"i3WQFzIXgRH0ET0FJ+J8PeakJr4VnA8USPT1dRCaHCgnP3oeyjzwcEpYkarGtynk",
                                     @"45tlH/2xDaL7TPeiTf5VjHuFjRbR+ePqAm/bydAZg6FlhGUV8ZK0h7qGFFdFDN67",
                                     @"8aTsKRKZXkpDraeberNCxkpYovWrsT9uWEOmZytYm6WeMj8eXl1Ac3rLqUBeTB7F",
                                     @"fVDrJ5awkwNLhxKJ+jD0L0KMkSLqtNughOLZ7oFNxi9Ga5ms/VhQc8+B1fmP6GFr",
                                     @"pd+j1yEgoajHjjlRGVGn/zevxwUPIvGPz7wfHo+C8vJPRuvQ0bFkBcNn/kLII2Pm",
                                     @"b8N8Su5BXrRPmVJzUMUUgauIWEkiWZ0LrcafPiV21KFcVE7D9BZoC1x0V5+EPH2c",
                                     @"o6DbxOSxwuiuIIBJX/FBt8jTSQWfo9xmTzUN3H8UJXKF61a8W1dI/ETVkhyhGu/N",
                                     @"Ipan14Y62Zq7a2+l3Z7uDcg9CAHVsgjuV7j1SRd0sciFS/z/jq6rKxTSGoKrR/NN",
                                     @"Fb/wbHSfWBGl3swhpYR/+mi4tCo1P2uTB4tvN3MUzRwOE7DahFl3pmoYXs0guzse",
                                     @"NNaGsm03eeGKfOpH/Ld1FJKzVxhZdxHOkgPQAwvxcfbdbQ2DshoLqa+GsqdKzAqK",
                                     @"6+VblUpHeoD06d/ZvMotYi4i+GETdR0YZIicM6t98pTPiN2ULhuwIOnnTEfz3xl5",
                                     @"ZGHhtvb84kUiTsjwU18nsK5u4qa6XLz5EAkSbpxE3tnWxKcYN2jd2vOzeR/gZ2as",
                                     @"Zb8V43n9D1Yjbo8s6b0lo1CQ6+1vbf8eO/e8sf7aD/7r7rf9AxJxvtvg5ylsMIIC",
                                     @"+QYJKoZIhvcNAQcBoIIC6gSCAuYwggLiMIIC3gYLKoZIhvcNAQwKAQKgggKmMIIC",
                                     @"ojAcBgoqhkiG9w0BDAEDMA4ECA8FRTbqH2YxAgIIAASCAoALZIQj5lGJ9mK2arRA",
                                     @"igFRT9+1UJu8homkgA3LQmsa4caXccLNRF1UkYBUk9vjgwZPEMkJJTNWNi8bMgng",
                                     @"UkzT+LLYRi06OhkLx4QBXcF21lfg1D3iyBwkJXXA0eZ+4sbD6EDgnFFkkVq4qj5x",
                                     @"oJtr3QbTvypUoaeWunsoJheZAYWL0OTk2CfURfsj/wBeYUaSk7zHMT01l5+IpypE",
                                     @"C/vxP3aYBpk7CyO/52TCDeB4c+LKnSHUXqmdyvD9yUeKMe//lSwz6ghkgkOqAHt6",
                                     @"dSFwaR878ErrDRFzCIZX5VoW/ofLgy56oFKEpelDUK16qiTgp2As+QokTgrO061w",
                                     @"MHE3LngS2Mhjos5NndXFJH3iZI1PrFhQ1DkTJrnDVnvKDl1mqAM7Jsb5FbzgE+8a",
                                     @"JmGzPNJji3NpSnWQEXmFuZqhScACmwvEU30eQJ6eo9JvgcNpfjVocKwbJc2ghQlN",
                                     @"cqBooNHye9XiVcgHzLvNtW0tpnAf9ViS4ctSalRirFJwZVAtfauvWdbMHpOHMPv+",
                                     @"Ro0fiCYmJ/yWXRrFKzbUygkROc8Y2e1QO5rTiuhXFDoQ3fkbb9JZ+mvYrKsEE+9z",
                                     @"fU8hXM+8ScVXZow0e2iKdMgrHM1u8PwQfbHef5f1UvX3FvbLVSN3y0GoNK96L5jq",
                                     @"lnjvUilloK0LyO6wti8JNa7kQItceHZmczPRnwwPJbkg9T2m5Cqm1LmkKob4Luay",
                                     @"ghwNCyBfszOjDWNoflpU+uK1YZecBj7O1kygrLpbtz6Z9tyKwu5i27/yndPX3kYN",
                                     @"Iz4v71nOYyUxl0LWl73bKthLMzFguRnpjmpCuX5/4YhzDanNXL0cXoruV49BCfuA",
                                     @"TxxyMSUwIwYJKoZIhvcNAQkVMRYEFFfDIHdGqv40JGS+zx4ySAjhwG6YMDEwITAJ",
                                     @"BgUrDgMCGgUABBRdFhfanDlwtVBsn5qXVHj3c8J5ZwQIyqccZBoAeRUCAggA"
                                     ];
        
        _p12Key = p12Base64String;
        
        // or
        
//        _p12Key = @" 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";
    }
    
    return _p12Key;
}

+(NSString*) p12Password
{
    if (! _p12Password) {
        _p12Password = @"ISAACS";
    }
    return _p12Password;
}



@end
