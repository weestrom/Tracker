#!/usr/bin/perl

#######################################################################################
#                 Copyright (c) 2013 Digitronix, Inc.                                 #
#					 All rights reserved											  #
#######################################################################################

use lib "./lib";
use App;
use strict;

my $app = App->new;
$app->start('daemon');
