unit class Core::Genesis;
use Digest::SHA;

subset Version of Str where * > 0;

class Block {
  has Version $.version = "1.0";
  has UInt $.prev-block = 0;
  has $.merkle-root = 0x3becdcce98e8;
  has $.timestamp = now;
  has $.bits = 786788989;
  has $.nonce = 877567682019838;
  has $.number-of-transactions = 1;
  has $.input;
  has $.previous-output;
  has $.script-length;
  has $.script-signature;
  has $.sequence;
  has $.outputs;
  has $.value;
  has $.pk-script-length;
  has $.pk-script;
  has $.locktime;

  method say-hello-from-genesis {
    print "Hello, from Genesis. My version is $.version\n";
  }

  method create-genesis {
    if "blocks/bl000000.dat".IO.e { return True; }
    else {
      my $data = "test data";
      'blocks/bl000000.dat'.IO.spurt: sha256 $data.encode: 'ascii';
      return False;
    }
  }
}

#`{ BLOCK COMMENTS
  01000000 - version
  0000000000000000000000000000000000000000000000000000000000000000 - prev block
  3BA3EDFD7A7B12B27AC72C3E67768F617FC81BC3888A51323A9FB8AA4B1E5E4A - merkle root
  29AB5F49 - timestamp
  FFFF001D - bits
  1DAC2B7C - nonce
  01 - number of transactions
  01000000 - version
  01 - input
  0000000000000000000000000000000000000000000000000000000000000000FFFFFFFF - prev output
  4D - script length
  04FFFF001D0104455468652054696D65732030332F4A616E2F32303039204368616E63656C6C6F72206F6E206272696E6B206F66207365636F6E64206261696C6F757420666F722062616E6B73 - scriptsig
  FFFFFFFF - sequence
  01 - outputs
  00F2052A01000000 - 50 BTC
  43 - pk_script length
  4104678AFDB0FE5548271967F1A67130B7105CD6A828E03909A67962E0EA1F61DEB649F6BC3F4CEF38C4F35504E51EC112DE5C384DF7BA0B8D578A4C702B6BF11D5FAC - pk_script
  00000000 - lock time
}
