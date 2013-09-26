use utf8;
package AppDB::Schema::Result::Outbound;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AppDB::Schema::Result::Outbound - VIEW

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<outbound>

=cut

__PACKAGE__->table("outbound");

=head1 ACCESSORS

=head2 uuid

  data_type: 'char'
  is_nullable: 0
  size: 36

=head2 recdate

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 tracnum

  data_type: 'char'
  is_nullable: 1
  size: 20

=head2 trlrnum

  data_type: 'char'
  is_nullable: 1
  size: 20

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
  "uuid",
  { data_type => "char", is_nullable => 0, size => 36 },
  "recdate",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "tracnum",
  { data_type => "char", is_nullable => 1, size => 20 },
  "trlrnum",
  { data_type => "char", is_nullable => 1, size => 20 },
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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-09-25 18:19:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OpCpPctOffv/wOgX0klcRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
