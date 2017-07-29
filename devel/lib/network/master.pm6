use JSON::Tiny;
use grammars;

subset NodeName of Str where *.chars <= 144;
subset NodeType of Str where "Full" | "Archive" | "Pruned" | "SPV";
subset NodePort of UInt where * <= 65535;

class EC::P2P::Master::Config {
  has %.parsed;
  has NodeName $.name = %!parsed<name>;
  has NodeType $.type = %!parsed<type>;
  has NodePort $.port = %!parsed<port>;
  has $.sources = %!parsed<sources>;
  has $.tests = %!parsed<tests>;
}

class EC::P2P::Master {

  has EC::P2P::Master::Config $.config;
  has @siblings;

  method awake {
    if !"config/master-nodes.json".IO.e { return False; }
    else {
      my $json = 'config/master-nodes.json'.IO.slurp;
      #say "Text slurped $text";
      $!config = EC::P2P::Master::Config.new( :parsed(from-json( $json )) );
      say $!config.port;
      return True;
    }
    #say "Master Node awakening... My name is $.name";

  }

  method connect {
    say "Digging... " ~ $!config.tests[0];
    my $proc = run 'dig', $!config.tests[0], :out, :err;
    my $output = $proc.out.slurp: :close;
    self!parse-dig( :output( $output ) );
    #say $captured-output.perl();
    #say $captured-output;
  }

  method !parse-dig( :$output ) {
    say "Processing Dig... ";
    my $dig = EC::Grammars::DIG.new.parse( $output,
                                           :actions( EC::Grammars::DIG::Actions.new ) );
    for $dig<ANSWER> -> $answers {
      say $answers<IP>;
    }
  }



}
