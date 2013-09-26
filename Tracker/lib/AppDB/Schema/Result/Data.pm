use utf8;
package AppDB::Schema::Result::Data;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AppDB::Schema::Result::Data

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Data>

=cut

__PACKAGE__->table("Data");

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

=head2 direction

  data_type: 'char'
  is_nullable: 0
  size: 8

=head2 rectimestamp

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

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
  "direction",
  { data_type => "char", is_nullable => 0, size => 8 },
  "rectimestamp",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</uuid>

=back

=cut

__PACKAGE__->set_primary_key("uuid");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-09-25 18:19:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Cd7YC6dmpXK75w9vswtwQA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
