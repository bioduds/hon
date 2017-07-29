# This is blake-512 implementation

sub infix:< 〇 >($x, $n) { $x +< (64-$n) | $x +> $n } ## an operator for the rotation
sub infix:< xor >($a, $b) { $a +^ $b }
sub infix:<	⏪ >($a, $b) { $a +< $b }
sub infix:<	⏩ >($a, $b) { $a +> $b }

subset UInt8_t of UInt where { ... }
subset UInt64_t of UInt64 where { ... }

my UInt8_t @sigma[*;16] = [ <0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>,
                            <14, 10 4 8 9 15 13 6 1 12 0 2 11 7 5 3>,
                            <11 8 12 0 5 2 15 13 10 14 3 6 7 1 9 4>,
                            <7 9 3 1 13 12 11 14 2 6 5 10 4 0 15 8>,
                            <9 0 5 7 2 4 10 15 14 1 11 12 6 8 3 13>,
                            <2 12 6 10 0 11 8 3 4 13 7 5 15 14 1 9>,
                            <12 5 1 15 14 13 4 10 0 7 6 3 9 2 8 11>,
                            <13 11 7 14 12 1 3 9 5 0 15 4 8 6 2 10>,
                            <6 15 14 9 11 3 0 8 12 2 13 7 1 4 10 5>,
                            <10 2 8 4 7 6 1 5 15 11 9 14 3 12 13 0>,
                            <0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>,
                            <14 10 4 8 9 15 13 6 1 12 0 2 11 7 5 3>,
                            <11 8 12 0 5 2 15 13 10 14 3 6 7 1 9 4>,
                            <7 9 3 1 13 12 11 14 2 6 5 10 4 0 15 8>,
                            <9 0 5 7 2 4 10 15 14 1 11 12 6 8 3 13>,
                            <2 12 6 10 0 11 8 3 4 13 7 5 15 14 1 9> ];

my UInt64_t @u512[16] =  <0x243f6a8885a308d3ULL, 0x13198a2e03707344ULL,
                          0xa4093822299f31d0ULL, 0x082efa98ec4e6c89ULL,
                          0x452821e638d01377ULL, 0xbe5466cf34e90c6cULL,
                          0xc0ac29b7c97c50ddULL, 0x3f84d5b5b5470917ULL,
                          0x9216d5d98979fb1bULL, 0xd1310ba698dfb5acULL,
                          0x2ffd72dbd01adfb7ULL, 0xb8e1afed6a267e96ULL,
                          0xba7c9045f12c7f99ULL, 0x24a19947b3916cf7ULL,
                          0x0801f2e2858efc16ULL, 0x636920d871574e69ULL>;

my UInt8_t @padding[129] = <0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>;

class state512 {
  has UInt64 @.h[8];
  has UInt64 @.s[4];
  has UInt64 @.t[2];
  has Int $.buflen;
  has Int $.nullt;
  has UInt8_t @.buf[128];
}

sub U8TO32_BIG( $p ) { ... }
sub U32TO8_BIG( $p, $v ) { ... }
sub U8TO64_BIG( $p ) { ... }
sub U64TO8_BIG( $p, $v ) { ... }

class EC::X17::blake512 {

  method compress( state512 :$s512 is copy, UInt8_t :$block is copy ) {

    my UInt64_t @v[16];
    my UInt64_t @m[16];
    my UInt64_t $i;

    sub G( $a, $b, $c, $d, $e ) {
      @v[$a] += (@m[@sigma[$i;$e]] xor @u512[@sigma[$i][$e+1]]) + @v[$b];
      @v[$d] = (@v[$d] xor @v[$a]) 〇 31;
      @v[$c] += @v[$d];
      @v[$b] = (@v[$b] xor @v[$c]) 〇 25;
      @v[$a] += (@m[@sigma[$i][$e+1]] xor @u512[@sigma[$i][$e]]) + @v[$b];
      @v[$d] = (@v[$d] xor @v[$a]) 〇 16;
      @v[$c] += @v[$d];
      @v[$b] = (@v[$b] xor @v[$c]) 〇 11;
    }

    for 0..16 -> $i { @m[$i] = U8TO64_BIG( $block + $i * 8 ); }
    for 0..8 -> $i { @v[$i] = $s512.h[$i]; }

    @v[8]  = $s512.s[0] xor @u512[0];
    @v[9]  = $s512.s[1] xor @u512[1];
    @v[10] = $s512.s[2] xor @u512[2];
    @v[11] = $s512.s[3] xor @u512[3];
    @v[12] = @u512[4];
    @v[13] = @u512[5];
    @v[14] = @u512[6];
    @v[15] = @u512[7];

    # don't xor t when the block is only padding
    if not $s512.nullt {
      @v[12] xor= $s512.t[0];
      @v[13] xor= $s512.t[0];
      @v[14] xor= $s512.t[1];
      @v[15] xor= $s512.t[1];
    }

    for 1..16 -> $i {
      G( 0, 4, 8, 12, 0 );
      G( 1, 5, 9, 13, 2 );
      G( 2, 6, 10, 14, 4 );
      G( 3, 7, 11, 15, 6 );
      # diagonal step
      G( 0, 5, 10, 15, 8 );
      G( 1, 6, 11, 12, 10 );
      G( 2, 7, 8, 13, 12 );
      G( 3, 4, 9, 14, 14 );
    }

    for 1..16 -> $i { $s512.h[i%8] xor= @v[$i]; }
    for 1..8 -> $i { $s512.h[i] xor= $s512[$i%4]; }

  }

  method init( state512 :$s512 is copy ) {
    $s512.h[0] = 0x6a09e667f3bcc908;
    $s512.h[1] = 0xbb67ae8584caa73b;
    $s512.h[2] = 0x3c6ef372fe94f82b;
    $s512.h[3] = 0xa54ff53a5f1d36f1;
    $s512.h[4] = 0x510e527fade682d1;
    $s512.h[5] = 0x9b05688c2b3e6c1f;
    $s512.h[6] = 0x1f83d9abfb41bd6b;
    $s512.h[7] = 0x5be0cd19137e2179;
    $s512.t[0] = $s512.t[1] = $s512.buflen = $s512.nullt = 0;
    $s512.s[0] = $s512.s[1] = $s512.s[2] = $s512.s[3] = 0;
  }

  method update( state512 :$s512 is copy, UInt8_t :$in is copy, UInt64_t :$inlen ) {
    my Int $left = $s512.buflen;
    my Int $fill = 128 - $left;

    # data left and data received fill a block
    if ( $left && ( $inlen >= $fill ) ) {
      # memcpy( ( void * ) ( S->buf + left ), ( void * ) in, fill );
      copy( $s512.buf + $left, $in, $fill ); # change this try Buf copy
      $s512.t[0] += 1024;

      if ( $s512.t[0] == 0 ) {
        $s512.t[1]++;
      }

      self.compress( :s512($s512), :block($s512.buf) );

      $in += $fill;
      $inlen -= $fill;
      $left = 0;

    }

    # compress blocks of data received
    while ( $inlen >= 128 ) {
      $s512.t[0] += 1024;

      if ( $s512.t[0] == 0 ) {
        $s512.t[1]++;
      }

      self.compress( :s512($s512), :block($in) );
      $in += 128;
      $inlen -= 128;

    }

    # store any data left
    if ( $inlen > 0 ) {
      # memcpy( ( void * ) ( S->buf + left ), ( void * ) in, ( size_t ) inlen );
      $s512.buflen = $left + $inlen.Int; # (int) inlen -> watch out
    } else {
      $s512.buflen = 0;
    }

  }

  method final( state512 :$s512 is copy, UInt8_t :$out is copy ) {
    my UInt8_t @msglen[16];
    my UInt8_t $zo = 0x01;
    my UInt8_t $oo = 0x81;
    my UInt64_t $lo = $s512.t[0] + $s512.buflen ⏪ 3;
    my UInt64_t $hi = $s512.t[1];

    if ( $lo < ($s512.buflen ⏪ 3) ) { $hi++; }

    U64TO8_BIG( @msglen + 0, $hi );
    U64TO8_BIG( @msglen + 8, $lo );

    if ( $s512.buflen == 111 ) { # one padding byte
      $s512.t[0] -= 8;
      self.update( $s512, $oo, 1 );
    } else {

      if ( $s512.buflen < 111 ) { # enough space to fill the block
        if ( !$s512.buflen ) { $s512.nullt = 1; }
        $s512.t[0] -= 888 - ( $s512.buflen ⏪ 3 );
        self.update( $s512, @padding, 111 - $s512.buflen );
      } else {
        $s512.t[0] -= 1024 - ( $s512.buflen ⏪ 3 );
        self.update( $s512, @padding, 128 - $s512.buflen );
        $s512.t[0] -= 888;
        self.update( $s512, @padding + 1, 111 );
        $s512.nullt = 1;
      }

      self.update( $s512, $zo, 1 );
      $s512.t[0] -= 8;

    }

    $s512.t[0] -= 128;
    self.update( $s512, @msglen, 16 );
    U64TO8_BIG( $out + 0, $s512.h[0] );
    U64TO8_BIG( $out + 8, $s512.h[1] );
    U64TO8_BIG( $out + 16, $s512.h[2] );
    U64TO8_BIG( $out + 24, $s512.h[3] );
    U64TO8_BIG( $out + 32, $s512.h[4] );
    U64TO8_BIG( $out + 40, $s512.h[5] );
    U64TO8_BIG( $out + 48, $s512.h[6] );
    U64TO8_BIG( $out + 56, $s512.h[7] );

  }

  method hash( UInt8_t :$out is copy, UInt8_t :$in is copy, UInt64_t :$inlen ) {
    my state512 $s512;
    self.init( $s512 );
    self.update( $s512, $in, $inlen );
    self.final( $s512, $out );
  }

  method test {
    my Int $i;
    my Int $v;
    my UInt8_t @in[144];
    my UInt8_t @out[64];
    my UInt8_t @test1 = <0x97, 0x96, 0x15, 0x87, 0xf6, 0xd9, 0x70, 0xfa, 0xba, 0x6d, 0x24, 0x78, 0x04, 0x5d, 0xe6, 0xd1,
                        0xfa, 0xbd, 0x09, 0xb6, 0x1a, 0xe5, 0x09, 0x32, 0x05, 0x4d, 0x52, 0xbc, 0x29, 0xd3, 0x1b, 0xe4,
                        0xff, 0x91, 0x02, 0xb9, 0xf6, 0x9e, 0x2b, 0xbd, 0xb8, 0x3b, 0xe1, 0x3d, 0x4b, 0x9c, 0x06, 0x09,
                        0x1e, 0x5f, 0xa0, 0xb4, 0x8b, 0xd0, 0x81, 0xb6, 0x34, 0x05, 0x8b, 0xe0, 0xec, 0x49, 0xbe, 0xb3>;

    my UInt8_t @test2 =  <0x31, 0x37, 0x17, 0xd6, 0x08, 0xe9, 0xcf, 0x75, 0x8d, 0xcb, 0x1e, 0xb0, 0xf0, 0xc3, 0xcf, 0x9f,
                          0xC1, 0x50, 0xb2, 0xd5, 0x00, 0xfb, 0x33, 0xf5, 0x1c, 0x52, 0xaf, 0xc9, 0x9d, 0x35, 0x8a, 0x2f,
                          0x13, 0x74, 0xb8, 0xa3, 0x8b, 0xba, 0x79, 0x74, 0xe7, 0xf6, 0xef, 0x79, 0xca, 0xb1, 0x6f, 0x22,
                          0xCE, 0x1e, 0x64, 0x9d, 0x6e, 0x01, 0xad, 0x95, 0x89, 0xc2, 0x13, 0x04, 0x5d, 0x54, 0x5d, 0xde>;

  # memset( in, 0, 144 );
    self.hash( @out, @in, 1 );
    $v = 0;

    for 1..64 -> $i {
      if ( @out[$i] != @test1[$i] ) { $v = 1; }
    }

    with $v { say "test 1 error"; }

    self.hash( @out, @in, 144 );

    $v = 0;

    for 1..64 -> $i {
      if ( @out[$i] != @test2[$i] ) { $v = 1; }
    }

    with $v { say "test 2 error"; }

  }

}
