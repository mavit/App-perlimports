use strict;
use warnings;

use lib 't/lib';

use App::perlimports::CLI ();
use Capture::Tiny qw( capture );
use Test::More import => [ 'done_testing', 'is', 'subtest' ];

subtest '--filename' => sub {
    my $expected = <<'EOF';
use strict;
use warnings;

use Perl::Critic::Utils qw( $QUOTE );

my %foo = (
    $QUOTE => q{description},
);
EOF

    local @ARGV = ( '-f', 'test-data/var-in-hash-key.pl', );
    my $cli = App::perlimports::CLI->new;
    my ($stdout) = capture {
        $cli->run;
    };
    is( $stdout, $expected, 'parses filename' );
};

subtest '--ignore-modules' => sub {
    my $expected = <<'EOF';
use strict;
use warnings;

use Perl::Critic::Utils;

my %foo = (
    $QUOTE => q{description},
);
EOF

    local @ARGV = (
        '--ignore-modules',
        'Perl::Critic::Utils',
        '-f',
        'test-data/var-in-hash-key.pl',
    );
    my $cli = App::perlimports::CLI->new;
    my ($stdout) = capture {
        $cli->run;
    };
    is( $stdout, $expected, );
};

subtest '--never-export-modules' => sub {
    my $expected = <<'EOF';
use strict;
use warnings;

use Perl::Critic::Utils ();

my %foo = (
    $QUOTE => q{description},
);
EOF

    local @ARGV = (
        '--never-export-modules',
        'Perl::Critic::Utils',
        '-f',
        'test-data/var-in-hash-key.pl',
    );
    my $cli = App::perlimports::CLI->new;
    my ($stdout) = capture {
        $cli->run;
    };
    is( $stdout, $expected );
};

subtest '--no-padding' => sub {
    my $expected = <<'EOF';
use strict;
use warnings;

use Perl::Critic::Utils qw($QUOTE);

my %foo = (
    $QUOTE => q{description},
);
EOF

    local @ARGV = ( '--no-padding', '-f', 'test-data/var-in-hash-key.pl', );
    my $cli = App::perlimports::CLI->new;
    my ( $stdout, $stderr ) = capture {
        $cli->run;
    };
    is( $stdout, $expected );
};

done_testing();
