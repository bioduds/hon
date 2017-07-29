#unit package EC::Network:auth<github:bioduds>;
unit module EC::Network;

# loop {
#   sleep-until now+2;
#   my $conn = IO::Socket::INET.new( :host<35.167.61.56>, :port(5000) );
#   say "Client sending message...";
#   $conn.print: 'Hello, Perl 6 here';
#   say $conn.recv;
#   $conn.close;
# }

#subset IP of Str where * ~~ ( \d+ \. \d+ \. \d+ \. \d+ );

class Client {
  has $.destination;
  has $.port;

  method send( :$message ) {
    await IO::Socket::Async.connect( $!destination, $!port ).then( -> $p {
      if $p.status {
        given $p.result {
          .print( $message ); ## this is sent
          react {
            whenever .Supply() -> $v {
              say "Sending " ~ $v;
              done;
            }
          }
          .close;
        }
      }
    });
  }

}
