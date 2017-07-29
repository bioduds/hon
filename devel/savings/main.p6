use v6;
use lib 'lib/core';
use master;
use genesis;
use merkle;

subset BlocksizeLimit of UInt where * < 2**1024;

## BUILD CONSTANTS WITH BINDING operators
my BlocksizeLimit $BLOCKSIZE := 4096;

shell "date";
print "my constant blocksize value is $BLOCKSIZE\n";
print "Initializing Proceedures...\nWelcome to EscrowChain\n";

Core::Config.start;
my $genesis = Core::Genesis.new;
$genesis.say-hello-from-genesis;

print "Testing Module Merkle...\n";

my @dataset = <one two three four>;
my $merkle = BW::Merkle::Tree.new( :dataset(@dataset) );
print "Merkle Root: $merkle.get-root()";

print "\n+++ end +++\n";
