package App::errnos;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

our @ERRNOS;
{
    my $i = 0;
    local $!;
    while (1) {
        $i++;
        $! = $i;
        my $msg = "$!";
        last if $msg =~ /unknown error/i;
        push @ERRNOS, [$i, $msg];
        # hard limit
        last if $i > 1000;
    }
}

my $res = gen_read_table_func(
    name       => 'list_errnos',
    summary    => 'List possible $! ($OS_ERROR, $ERRNO) values on your system',
    description => <<'_',

_
    table_data => \@ERRNOS,
    table_spec => {
        summary => 'List of possible $! ($OS_ERROR, $ERRNO) values',
        fields  => {
            number => {
                schema   => 'int*',
                index    => 0,
                sortable => 1,
            },
            string => {
                schema   => 'str*',
                index    => 1,
            },
        },
        pk => 'number',
    },
    enable_paging => 0,
    enable_random_ordering => 0,
);
die "Can't generate list_errnos function: $res->[0] - $res->[1]"
    unless $res->[0] == 200;

$SPEC{list_errnos}{args}{query}{pos} = 0;
$SPEC{list_errnos}{args}{detail}{cmdline_aliases} = {l=>{}};
$SPEC{list_errnos}{args}{query}{pos} = 0;
$SPEC{list_errnos}{examples} = [
    {
        summary => 'List possible errno numbers with their messages',
        argv => ["-l"],
    },
    {
        summary => 'Search specific errnos',
        argv => ["-l", "No such"],
    },
];

1;
# ABSTRACT:

=head1 SEE ALSO

perldata

=cut
