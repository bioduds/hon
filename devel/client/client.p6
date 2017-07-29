use v6;

# loop {
#   sleep-until now+2;
#   my $conn = IO::Socket::INET.new( :host<35.167.61.56>, :port(5000) );
#   say "Client sending message...";
#   $conn.print: 'Hello, Perl 6 here';
#   say $conn.recv;
#   $conn.close;
# }

await IO::Socket::Async.connect('35.167.61.56', 5000).then( -> $p {
  if $p.status {
    given $p.result {
      .print('Hello, Perl 6');
      react {
        whenever .Supply() -> $v {
          $v.say;
          done;
        }
      }
      .close;
    }
  }
});
