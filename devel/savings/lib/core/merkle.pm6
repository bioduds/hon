unit class BW::Merkle;
use Digest::SHA;

class Tree {
  has $.root;
  has $!height;
  has @!dataset;

  submethod BUILD ( :@dataset ) {
    # check if elems is odd and duplicate last if so
    @!dataset = @dataset;
    if ( @!dataset.elems % 2 == 1 ) {
      @!dataset.push( @dataset.pop );
    }
    my @new-dataset;
    for @!dataset -> $data {
      my $sha256 = sha256 $data.encode: 'ascii';
      sub buf_to_hex { [~] $^buf.list».fmt: "%02x" }
      @new-dataset.push( buf_to_hex $sha256 );
    }
    @!dataset = @new-dataset;
    $!height = log( @!dataset.elems, 2 ) + 1;
    print "On constructor I got " ~ @!dataset ~ " with height $!height\n";
  }

  method get-root() {
    my @line = @!dataset;
    loop ( my $h=$!height-1; $h >= 0; $h-- ) {
      print "h: $h\n";
      loop ( my $i=0; $i < @!dataset.elems/($!height-$h); $i+=2 ) {
        print "i: $i\n";
        my $sha256 = sha256 (@line[$i]~@line[$i+1]).encode: 'ascii';
        sub buf_to_hex { [~] $^buf.list».fmt: "%02x" }
        say my $data = buf_to_hex $sha256;
        @line[$i/2] = $data;
      }
    }
    return @line[0];
  }

  method !perform-hash( $node ) {
    return sha256 $node.encode: 'ascii';
  }

}
