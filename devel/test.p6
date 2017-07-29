use v6;
use lib 'lib/network';
use lib 'test';
use DAG;

say "Running Test... Initializing";
say "Let's try out a DAG with a Markov Blanket... ";

my $genesis = EC::DAG::Genesis.new(
  :ID( "adsfdsfdf" ),
  :timestamp( "87877857567" ),
  :nonce( "88798798789" ),
  :SEED( "9GENESIS9GENESIS9GENESIS9GENESIS9GENESIS9GENESIS9GENESIS9GENESIS9GENESIS9GENESIS9" )
);
$genesis.birth;
