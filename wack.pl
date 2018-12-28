#!/usr/bin/perl

use strict;
use warnings;
use BerkeleyDB;

my $DEBUG = $ENV{DEBUG} || 0;
my %wallet;
my $filename = shift || 'wallet.dat';
my $db  = tie %wallet, 'BerkeleyDB::Btree',
        -Filename => $filename,
        -Subname  => "main",
        -Flags => DB_RDONLY,
    or die  "Cannot open file $filename: $! $BerkeleyDB::Error\n";

my $counts = {};
while (my ($k,$v) = each %wallet) {
    my $len  = unpack("W", substr($k, 0, 1));
    my $type = substr $k, 1, $len;
    my $key  = substr $k, $len+1;
    my $vlen = length $v;

    #printf "%s => %x\n", $k, $v;
    if ($DEBUG) {
        if ($type eq 'key') {
            my $privkey = unpack("H*", $v);
            $key = unpack("H*", $key);
            print "key=$key, privkey=$privkey\n";
        } elsif ($type eq 'tx') {
            my $tx  = unpack("h*", $key);
            my $vtx = unpack("h*", $v);
            my $l   = length($tx);
            my $lvtx= length($vtx);
            print "len=$l tx=$tx, $vtx ($lvtx bytes)\n";
        } elsif ($type eq 'defaultkey') {
            my $dkey = unpack("H*", $v);
            print "defaultkey=$dkey\n";
        } elsif ($type eq 'zkey') {
            my $privkey = unpack("H*", $v);
            $key = unpack("H*", $key);
            print "zkey=$key, privkey=$privkey\n";
        } elsif ($type eq 'name') {
            print "name: $key, $v\n";
        } elsif ($type eq 'bestblock') {
            my $len = length $v;
            print "bestblock ($len bytes):\nbestblock: $key, $v\n";
        } elsif ($type eq 'version') {
            my $len = length $v;
            my $version = unpack("I", $v);
            print "version ($len bytes): $version\n";
        } else {
            my $len = length $v;
            my $v   = unpack("I", $v);
            print "$type ($len bytes): $key, $v\n";
        }
        printf "$vlen $type %s:\n", $key;
    }
    $counts->{$type}++;
}

printf "\n=====Wallet Key Stats=====\n";
my @keys  = sort { $counts->{$b} <=> $counts->{$a} } keys(%$counts);
for my $k (@keys) {
    printf "%-25s %s\n", $k, $counts->{$k};
}

