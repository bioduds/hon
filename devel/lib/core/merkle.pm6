use Digest::SHA;

class EC::Merkle::Tree {

  has @.dataset;
  has @!nodes;

  method !set-nodes {
    if ( @.dataset.elems % 2 == 1 ) {
      @.dataset.push( @.dataset.pop );
    }
    @!nodes = [];
    for @.dataset -> $data {
      my $sha256 = sha256 $data.encode: 'ascii';
      sub buf_to_hex { [~] $^buf.list».fmt: "%02x" }
      @!nodes.push( buf_to_hex $sha256 );
    }
  }

  method get-root {
    self!set-nodes;
    for reverse 1..^self.height -> $h {
      my @current_line = [];
      for @!nodes -> $a, $b {
        my $sha256 = sha256 ($a~$b).encode: 'ascii';
        sub buf_to_hex { [~] $^buf.list».fmt: "%02x" }
        @current_line.push( buf_to_hex $sha256 );
      }
      @!nodes = @current_line;
    }
    return @!nodes[0];
  }

  method height {
    return log( @.dataset.elems, 2 ) + 1;
  }

}
