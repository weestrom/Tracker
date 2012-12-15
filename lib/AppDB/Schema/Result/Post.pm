package BlogDB::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

BlogDB::Schema::Result::Post

=cut

__PACKAGE__->table("Posts");

=head1 ACCESSORS

=head2 idposts

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 datelastedited

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 text

  data_type: 'longtext'
  is_nullable: 0

=head2 authors_idauthors

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 posturl

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "idposts",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "datelastedited",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "text",
  { data_type => "longtext", is_nullable => 0 },
  "authors_idauthors",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "posturl",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);
__PACKAGE__->set_primary_key("idposts", "authors_idauthors");

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<BlogDB::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "BlogDB::Schema::Result::Comment",
  { "foreign.posts_idposts" => "self.idposts" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 authors_idauthor

Type: belongs_to

Related object: L<BlogDB::Schema::Result::Author>

=cut

__PACKAGE__->belongs_to(
  "authors_idauthor",
  "BlogDB::Schema::Result::Author",
  { idauthors => "authors_idauthors" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-15 21:21:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gW4m1kGD6C68/y5Nqq8bDA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
