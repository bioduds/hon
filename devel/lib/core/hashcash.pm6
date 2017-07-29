
use Digest::SHA;


class EC::PoW::Hashcash {

  has $.prev-hash;

  method !gen-nonce( :$size ) {
    my $nonce ~= ("0".."z").pick for 0..$size;
    my $attempt = $.prev-hash ~ $nonce;
    return ($attempt, $nonce);
  }

  method mine( :$nonce-size, :$difficulty ) {

    loop {
      my ($attempt, $nonce) = self!gen-nonce( :size( $nonce-size ) );
      my $solution = sha256 $attempt.encode: 'ascii';
      sub buf_to_hex { [~] $^buf.list».fmt: "%02x" }
      my $sol = buf_to_hex $solution;
      if ( $sol.starts-with( '0' x $difficulty ) ) {
        say "Excellent! $sol";
        last;
      }
    }

  }

}
