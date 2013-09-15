use utf8;
package App::Schema::Result::Inbound;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Schema::Result::Inbound - VIEW

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<inbound>

=cut

__PACKAGE__->table("inbound");

=head1 ACCESSORS

=head2 tracnum

  data_type: 'integer'
  is_nullable: 1

=head2 trlrnum

  data_type: 'integer'
  is_nullable: 1

=head2 driver

  data_type: 'char'
  is_nullable: 1
  size: 30

=head2 origin

  data_type: 'char'
  is_nullable: 1
  size: 30

=head2 destination

  data_type: 'char'
  is_nullable: 1
  size: 30

=head2 appt

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 backhaul

  data_type: 'char'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "tracnum",
  { data_type => "integer", is_nullable => 1 },
  "trlrnum",
  { data_type => "integer", is_nullable => 1 },
  "driver",
  { data_type => "char", is_nullable => 1, size => 30 },
  "origin",
  { data_type => "char", is_nullable => 1, size => 30 },
  "destination",
  { data_type => "char", is_nullable => 1, size => 30 },
  "appt",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "backhaul",
  { data_type => "char", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-15 16:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vSXOi3JWptICEPqc3CvGIg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
