" Vim syntax file
" Language:     BIND zone files (RFC1035)
" Maintainer:   Mathieu Arnold <mat@mat.cc>
" URL:          https://github.com/Absolight/vim-bind
" Last Change:  Thu 2006-04-20 12:30:45 UTC
"
" Based on an earlier version by Julian Mehnle, with heavy modifications.

if exists("b:current_syntax")
  finish
endif

syn case match

" Directives
syn region      zoneRRecord             start=/\v^/ end=/\v$/ contains=zoneOwnerName,zoneSpecial,zoneTTL,zoneClass,zoneRRType,zoneComment,zoneUnknown

syn match       zoneDirective           /\v^\$ORIGIN\s+/   nextgroup=zoneOrigin,zoneUnknown
syn match       zoneDirective           /\v^\$TTL\s+/      nextgroup=zoneNumber,zoneUnknown
syn match       zoneDirective           /\v^\$INCLUDE\s+/  nextgroup=zoneText,zoneUnknown
syn match       zoneDirective           /\v^\$GENERATE\s/
hi def link     zoneDirective           Macro

syn match       zoneUnknown             contained /\v\S+/
hi def link     zoneUnknown             Error

syn match       zoneOwnerName           contained /\v^[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]+(\s|;)@=/ nextgroup=zoneTTL,zoneClass,zoneRRType skipwhite
hi def link     zoneOwnerName           Statement

syn match       zoneOrigin              contained  /\v[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]+(\s|;|$)@=/
hi def link     zoneOrigin              Statement

syn match       zoneDomain              contained  /\v[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]+(\s|;|$)@=/
hi def link     zoneDomain              Identifier

syn match       zoneSpecial             contained /\v^[@*.]\s/
hi def link     zoneSpecial             Special

syn match       zoneTTL                 contained /\v<(\d[HhWwDd]?)*>/ nextgroup=zoneClass,zoneRRType skipwhite
hi def link     zoneTTL                 Constant

syn keyword     zoneClass               contained IN CHAOS nextgroup=zoneRRType,zoneTTL   skipwhite
hi def link     zoneClass               Include

" From :
" http://www.iana.org/assignments/dns-parameters/dns-parameters.xml#dns-parameters-3
" keep sorted by rrtype value as possible, no obsolete or experimental RR.
syn keyword     zoneRRType              contained A nextgroup=zoneIPAddr skipwhite
syn keyword     zoneRRType              contained AAAA nextgroup=zoneIP6Addr skipwhite
syn keyword     zoneRRType              contained NS CNAME PTR DNAME nextgroup=zoneDomain skipwhite
syn keyword     zoneRRType              contained SOA WKS HINFO MX TXT RP
      \ AFSDB X25 ISDN RT NSAP NSAP-PTR SIG KEY PX GPOS LOC EID NIMLOC SRV
      \ ATMA NAPTR KX CERT SINK OPT APL DS SSHFP IPSECKEY RRSIG NSEC DNSKEY
      \ DHCID NSEC3 NSEC3PARAM TLSA HIP NINFO RKEY TALINK CDS SPF UINFO UID
      \ GID UNSPEC NID L32 L64 LP URI CAA TA DLV
      \ nextgroup=zoneRData skipwhite
syn match       zoneRRType              contained /\vTYPE\d+/ nextgroup=zoneUnknownType1 skipwhite
hi def link     zoneRRType              Type

syn match       zoneRData               contained /\v[^;]*/ contains=zoneDomain,zoneText,zoneNumber,zoneParen,zoneBase64,zoneUnknown

syn match       zoneIPAddr              contained /\v<[0-9]{1,3}(.[0-9]{1,3}){,3}>/
hi def link     zoneIPAddr              Number

"   Plain IPv6 address          IPv6-embedded-IPv4 address
"   ::[...:]8                   ::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v\s@<=::((\x{1,4}:){,5}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,6}\x{1,4})>/
"   1111::[...:]8               1111::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){1}:((\x{1,4}:){,4}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,5}\x{1,4})>/
"   1111:2::[...:]8             1111:2::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){2}:((\x{1,4}:){,3}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,4}\x{1,4})>/
"   1111:2:3::[...:]8           1111:2:3::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){3}:((\x{1,4}:){,2}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,3}\x{1,4})>/
"   1111:2:3:4::[...:]8         1111:2:3:4::[...:]127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){4}:((\x{1,4}:){,1}([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,2}\x{1,4})>/
"   1111:2:3:4:5::[...:]8       1111:2:3:4:5::127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){5}:(([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2}|(\x{1,4}:){,1}\x{1,4})>/
"   1111:2:3:4:5:6:7:8          1111:2:3:4:5:6:127.0.0.1
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){6}(\x{1,4}:\x{1,4}|([0-2]?\d{1,2}\.){3}[0-2]?\d{1,2})>/
"   1111:2:3:4:5:6::8           -
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){6}:\x{1,4}>/
"   1111[:...]::                -
syn match       zoneIP6Addr             contained /\v<(\x{1,4}:){1,7}:(\s|;|$)@=/
hi def link     zoneIP6Addr             Number

syn match       zoneText                contained /\v"([^"\\]|\\.)*"(\s|;|$)@=/
hi def link     zoneText                String

syn match       zoneNumber              contained /\v<[0-9]+(\s|;|$)@=/
hi def link     zoneNumber              Number

syn match       zoneSerial              contained /\v<[0-9]{9,10}(\s|;|$)@=/
hi def link     zoneSerial              Special

syn match       zoneBase64              contained /\v<[a-zA-Z0-9\/\=\+]+>/
hi def link     zoneBase64              String

syn match       zoneErrParen            /\v\)/
hi def link     zoneErrParen            Error

syn region      zoneParen               contained start="(" end=")" contains=zoneSerial,zoneNumber,zoneComment
syn match       zoneComment             /\v\;.*/
hi def link     zoneComment             Comment

syn match       zoneUnknownType1        contained /\v\\\#/ nextgroup=zoneUnknownType2 skipwhite
hi def link     zoneUnknownType1        Macro
syn match       zoneUnknownType2        contained /\v\d+/ nextgroup=zoneUnknownType3 skipwhite
hi def link     zoneUnknownType2        Number
syn match       zoneUnknownType3        contained /\v[0-9a-fA-F\ ]+/
hi def link     zoneUnknownType3        String

let b:current_syntax = "bindzone"

" vim:sts=2 sw=2
