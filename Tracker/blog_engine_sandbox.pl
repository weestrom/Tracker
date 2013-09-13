#!/usr/bin/perl
use lib "./lib";
use App;
use strict;

my $app = App->new;
$app->config(hypnotoad => {listen => ['http://*:80']});
$app->start('daemon');
