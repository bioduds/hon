use v6;
use config;
use genesis;
use merkle;

subset BlocksizeLimit of UInt where * < 2**1024;

## BUILD CONSTANTS WITH BINDING operators
my BlocksizeLimit $BLOCKSIZE := 4096;

shell "date";
print "my constant blocksize value is $BLOCKSIZE\n";
print "Initializing Proceedures...\n";

EC::Core::Config.apply;

print "Welcome to EscrowChain\n";


my $genesis = EC::Core::Genesis.new;
$genesis.say-hello-from-genesis;
my $gen-message = $genesis.create-genesis ?? "Genesis was created previously"
                                          !! "Genesis Block Created Successfully";
print "Genesis Creation: $gen-message\n";

my @ds = <one two three four>;
my $merkle = EC::Merkle::Tree.new( :dataset(@ds) );
say "Merkle Root: " ~ $merkle.get-root;

print "+++ end +++\n";
