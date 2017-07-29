#unit package EC::Network:auth<github:bioduds>;
unit module EC::Network;

class Socket {
  has IO::Socket::INET $.listener;
  method run {

    my $big-finish = Promise.new;
    my $tap = do whenever $!listener -> $conn {
      say "Reaction here...";
    }
    await $big-finish;
    $tap.close;

  }
}

# loop {
#   my $conn = $!listener.accept;
#   while my $buf = $conn.recv( :bin ) {
#     say "Node receiving message (raw)";
#     say $buf;
#     say "Node receiving message (decoded): " ~ $buf.decode( 'utf-8' );
#     $conn.write: $buf;
#   }
#   $conn.close;
# }
