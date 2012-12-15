 #!/usr/bin/perl
 # in a script
  use DBIx::Class::Schema::Loader qw/ make_schema_at /;
  my $DB_Database="blog";
	my $DB_Host="ziggurat";
	my $user="root";
	my $password="GU-eYu3ujAje!het";
	####################################################
	## This section should come from xml config later ##
	####################################################
	my $connectstr = "dbi:mysql:host=$DB_Host;database=$DB_Database";
  make_schema_at(
      'BlogDB::Schema',
      { dump_directory => './lib',
      },
      [ $connectstr, $user, $password
      ],
  );
