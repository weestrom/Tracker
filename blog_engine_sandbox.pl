#!/usr/bin/perl
use lib "./lib";
use App;
use strict;

my $app = App->new;
$app->start('daemon');

while(1){}