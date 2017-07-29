unit package EC::Network:auth<github:bioduds>;

use message;

## register class - rule is must be readable once
class Reader {
  has $.message;

  method read {
    say "Message Network system reading " ~ $!message;

    EC::Grammars::VERSION.new.parse(
      $!message, :actions( EC::Grammars::VERSION::Actions.new )
    );
    # EC::Grammars::VERACK.new.parse(
    #   $!message, :actions( EC::Grammars::VERACK::Actions.new )
    # );
    # EC::Grammars::ADDR.new.parse(
    #   $!message, :actions( EC::Grammars::ADDR::Actions.new )
    # );

  }

}
