 #!/usr/bin/perl
 # in a script
  use DBIx::Class::Schema::Loader qw/ make_schema_at /;
  my $DB_Database="Tracker";
	my $DB_Host="localhost";
	my $user="root";
	my $password="TR-tRa7pecR8";
	####################################################
	## This section should come from xml config later ##
	####################################################
	my $connectstr = "dbi:mysql:host=$DB_Host;database=$DB_Database";
  make_schema_at(
      'AppDB::Schema',
      { dump_directory => './lib',
      },
      [ $connectstr, $user, $password
      ],
  );
