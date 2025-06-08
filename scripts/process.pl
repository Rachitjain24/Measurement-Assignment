#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use URI::Escape;

# — read raw POST body from STDIN —
my $body = do { local $/; <STDIN> };

# — parse “name=…&email=…” into %params —
my %params = map {
    my ($k, $v) = split /=/, $_, 2;
    $k => uri_unescape($v // '')
} split /&/, $body;

my $name  = $params{name}  // '';
my $email = $params{email} // '';

# — print out HTML response —
print "Content-Type: text/html\n\n";
print <<"HTML";
<html>
  <head><title>Thank You!</title></head>
  <body>
    <h1>Submission Received</h1>
    <p><strong>Name:</strong>  $name</p>
    <p><strong>Email:</strong> $email</p>
    <p><a href="/view">See all submissions</a></p>
  </body>
</html>
HTML

# — append to data.txt in project root —
my $data_file = "$FindBin::Bin/../data.txt";
open my $out, '>>', $data_file
  or die "Cannot open $data_file for append: $!";
print $out "$name,$email\n";
close $out;
