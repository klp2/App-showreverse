use Test2::V0;
use Test2::Tools::Exception qw( dies );

use App::showreverse;

like(
    dies { App::showreverse->validate_args( [], [] ) },
    qr/Try #sr showreverse <space separated cidr blocks>\n/,
    'Died when no networks are provided',
);

my @non_cidr_things = ( 'h', ' ', '01.01.01.01', '256.256.256.256', '1/99' );
for my $non_cidr_thing (@non_cidr_things) {
    like(
        dies { App::showreverse->validate_args( [], [$non_cidr_thing] ) },
        qr/^Error: $non_cidr_thing is not a valid cidr block\n/,
        "Died on invalid cidr networks input, $non_cidr_thing",
    );
}

my @cidr_things = ( 1, '1', '192.168.1.0', '8.8.8.0/24', 0 );
for my $cidr_thing (@cidr_things) {
    is(
        App::showreverse->validate_args( [], [$cidr_thing] ), 1,
        "We validate $cidr_thing as a cidr thing"
    );
}

is(
    App::showreverse->validate_args( [1], [1] ), 1,
    'Does not die if there are options present'
);

done_testing();

# sub validate_args {
#     my ( $self, $opt, $args ) = @_;

#     if ( @{$args} < 1 ) {
#         $self->usage_error(
#             'Try #sr showreverse <space separated cidr blocks>');
#     }
#     my @blocks = @{$args};
#     for my $block (@blocks) {
#         unless ( cidrvalidate($block) ) {
#             $self->usage_error("$block is not a valid cidr block");
#         }
#     }
#     return 1;
# }
