#unit package EC::Network:auth<github:bioduds>;
unit module EC::DAG;

class Node {
  has $.ID is required;
  has $.timestamp is required;
  has $.nonce is required;
  has $.SEED is required;
}

role Blanket {
  has Node $.parents;
  has Node $.children;
  has Node $.children-parents;
}


class Genesis is Node is Blanket {
  has $.treasure = 85000000000000.000001;

  method birth {
    say "Setting up Treasure";
    self!init-local;
  }

  method !init-local {

    say "Init Local";
    self!begin-genesis-ritual;

  }

  method !begin-genesis-ritual {

    say "Beginning Genesis Ritual";
    say "We need to: ";
    say "1. Find all 7 Init Nodes";

    my $seven-status = self!find-seven-nodes;

  }

  method !find-seven-nodes {
    my @nodes;
    @nodes[1] = prompt "Enter 1st Node: ";
    @nodes[2] = prompt "Enter 2nd Node: ";
    @nodes[3] = prompt "Enter 3rd Node: ";
    @nodes[4] = prompt "Enter 4th Node: ";
    @nodes[5] = prompt "Enter 5th Node: ";
    @nodes[6] = prompt "Enter 6th Node: ";
    @nodes[7] = prompt "Enter 7th Node: ";

    @nodes[0] = $.nonce;

    for @nodes -> $node {
      print "Got: $node";
    }

    return True;

  }

}
