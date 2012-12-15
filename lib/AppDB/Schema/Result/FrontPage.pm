package BlogDB::Schema::Result::FrontPage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

BlogDB::Schema::Result::FrontPage

=cut

__PACKAGE__->table("FrontPage");

=head1 ACCESSORS

=head2 idposts

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 username

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 datelastedited

  data_type: 'timestamp'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 text

  data_type: 'longtext'
  is_nullable: 0

=head2 posturl

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 numberofcomments

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "idposts",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "username",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "datelastedited",
  {
    data_type     => "timestamp",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "text",
  { data_type => "longtext", is_nullable => 0 },
  "posturl",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "numberofcomments",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-15 21:49:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OFYRRV1if1G58Y0jBX/E0g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
