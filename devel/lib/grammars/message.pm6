#unit package EC::Grammars:auth<github:bioduds>;
unit module EC::Grammars;

## reusable grammars
grammar TIMESTAMP {
  rule MAIN { <WEEK-DAY> <MONTH> <DAY> <TIME> <PLACE> <YEAR> }
  token WEEK-DAY { \S+ }
  token MONTH { \S+ }
  token DAY { \d+ }
  token TIME { \d+ \: \d+ \: \d+ }
  token PLACE { \S+ }
  token YEAR { \d+ }
}

##
grammar VERSION {
  rule TOP { <GREETING> <NODE> <VERSION> <TIMESTAMP> }
  token GREETING { 'Hello,' | 'Hi,' | 'Good Morning,' }
  token NODE { 'I am ' ( \d+ \. \d+ \. \d+ \. \d+ ) }
  token VERSION { 'and my version is ' ( \d+ \. \d+ \. \d+ ) }
  token TIMESTAMP { 'at ' ( <TIMESTAMP::MAIN> ) }
}

class VERSION::Actions {
  has $.node;
  has $.version;
  has $.timestamp;
  method TOP ($/) {
    self!respond;
    say "VERSION::Greetings done!";
  }
  method GREETING ($/) { say 'Has greeting!'; }
  method NODE ($/) { say 'Has NODE ' ~ $/[0]; $!node = $/[0]; }
  method VERSION ($/) { say 'Has VERSION ' ~ $/[0]; $!version = $/[0]; }
  method TIMESTAMP ($/) { say 'Has TIMESTAMP ' ~ $/[0]; $!timestamp = $/[0]; }
  method !respond {
    say 'Responding to ' ~ $!node ~ ' with version ' ~ $!version ~ ' on ' ~ $!timestamp;
  }
}

grammar VERACK {
  rule TOP { <GREETING> <NODE> <VERSION>  }
  token GREETING { 'Hello' | 'Hi' | 'Yo' }
  token NODE { 'I am ' ( \d+ \. \d+ \. \d+ \. \d+ ) }
  token VERSION { 'and my version is ' ( \d+ \. \d+ \. \d+ ) }
}

class VERACK::Actions {
  method TOP ($/) { say "VERACK in action" }
  method GREETING { say "has GREETING"; }
  method NODE { say "has NODE"; }
  method VERSION { say "has VERSION"; }
}

grammar ADDR {
  rule TOP { <IDENTIFIER> <TIMESTAMP> <LINKER> <ADDRESS>+ }
  token IDENTIFIER { 'Right now, ' }
  rule TIMESTAMP { <WEEK-DAY> <MONTH> <DAY> <TIME> <PLACE> <YEAR> }
  token WEEK-DAY { \S+ }
  token MONTH { \S+ }
  token DAY { \d+ }
  token TIME { \d+ \: \d+ \: \d+ }
  token PLACE { \S+ }
  token YEAR { \d+ }
  token LINKER { 'I have' }
  rule ADDRESS { \d+ \. \d+ \. \d+ \. \d+ }
}

class ADDR::Actions {
  method TOP ($/) { say "ADDR went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method TIMESTAMP ($/) { say "Got TIMESTAMP " ~ $/; }
  method LINKER ($/) { say "Got LINKER " ~ $/; }
  method ADDRESS ($/) { say "Got ADDRESS " ~ $/; }
}

grammar INV {
  rule TOP { <IDENTIFIER> <INFO> }
  token IDENTIFIER { 'Hey, check this out: ' }
  rule INFO { ... }
}

class INV::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method INFO ($/) { say "Got INFO " ~ $/; }
}

grammar GET-DATA {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class GET-DATA::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar NOT-FOUND {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Sorry, this hasn\'t been found' }
  rule DATA { ... }
}

class NOT-FOUND::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got ID " ~ $/; }
}

grammar GET-BLOCKS {
  rule TOP { <IDENTIFIER> <BLOCKS>+ '  ' <NODE> }
  token IDENTIFIER { 'Please, ask for these blocks: ' }
  token BLOCKS { ... }
  token NODE { ... }
}

class GET-BLOCKS::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method BLOCKS ($/) { say "Asking for BLOCKS " ~ $/; }
  method NODE ($/) { say "to this NODE " ~ $/; }
}

grammar GET-HEADERS {
  rule TOP { <IDENTIFIER> <HEADERS>+ ' from ' }
  token IDENTIFIER { 'Please, get me these HEADERS: ' }
  token HEADERS { ... }
  token NODE { ... }
}

class GET-HEADERS::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method HEADERS ($/) { say "Got HEADERS " ~ $/; }
  method NODE ($/) { say "Got DATA " ~ $/; }
}

grammar TX {
  rule TOP { <IDENTIFIER> <TX> <NODE> }
  token IDENTIFIER { 'Here\'s the TX you asked: ' }
  token TX { ... }
  token NODE { ... }
}

class TX::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method TX ($/) { say "Sending TX " ~ $/; }
  method NODE ($/) { say "To this NODE " ~ $/; }
}

grammar BLOCK {
  rule TOP { <IDENTIFIER> <BLOCK> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class BLOCK::Actions {
  method TOP ($/) { say "Sending BLOCK information!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Sending DATA " ~ $/; }
}

grammar HEADERS {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class HEADERS::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar GET-ADDR {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class GET-ADDR::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar MEM-POOL {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class MEM-POOL::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar CHECK-ORDER {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class CHECK-ORDER::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar SUBMIT-ORDER {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class SUBMIT-ORDER::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar REPLY {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class REPLY::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar PING {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class PING::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar PONG {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class PONG::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar REJECT {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class REJECT::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar ALERT {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class ALERT::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar SEND-HEADERS {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class SEND-HEADERS::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}

grammar FEE-FILTERS {
  rule TOP { <IDENTIFIER> <DATA> }
  token IDENTIFIER { 'Hey, here\'s the data: ' }
  rule DATA { ... }
}

class FEE-FILTERS::Actions {
  method TOP ($/) { say "INV went through!" }
  method IDENTIFIER ($/) { say "Got IDENTIFIER " ~ $/; }
  method DATA ($/) { say "Got DATA " ~ $/; }
}
