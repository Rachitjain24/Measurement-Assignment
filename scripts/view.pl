#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;

# locate data.txt
my $data_file = "$FindBin::Bin/../data.txt";

# print HTML header with embedded CSS
print "Content-Type: text/html\n\n";
print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All Submissions</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0; padding: 20px;
    }
    .container {
      max-width: 800px;
      margin: auto;
      background: #fff;
      padding: 20px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.3);
      border-radius: 8px;
    }
    h1 {
      text-align: center;
      color: #333;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 12px;
      border: 1px solid #ddd;
      text-align: left;
    }
    tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    th {
      background-color: #007bff;
      color: #fff;
    }
    .back-link {
      margin-top: 20px;
      text-align: center;
    }
    .back-link a {
      color: #007bff;
      text-decoration: none;
    }
    .back-link a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>All Submissions</h1>
    <table>
      <tr><th>Name</th><th>Email</th></tr>
HTML

# read & emit table rows
open my $in, '<', $data_file or die "Cannot open $data_file: $!";
while (<$in>) {
    chomp;
    my ($n, $e) = split /,/, $_, 2;
    # simple HTML escape
    $n = qq{<span>} . $n . qq{</span>};
    $e = qq{<span>} . $e . qq{</span>};
    print "      <tr><td>$n</td><td>$e</td></tr>\n";
}
close $in;

# footer
print <<"HTML";
    </table>
    <div class="back-link">
      <a href="/">← Submit Another</a>
    </div>
  </div>
</body>
</html>
HTML
