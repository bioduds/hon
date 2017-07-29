class state512 {
  has @.h[3];
}

my $s = state512.new( :h(<1 2 3>) );
say $s.h[2];
