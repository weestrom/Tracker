#!/usr/bin/perl
use lib "./lib";
use BlogApp;
use strict;

my $app = BlogApp->new;
$app->start('daemon');

while(1){}