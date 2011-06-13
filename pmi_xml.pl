#!/usr/bin/perl
# this script will do pruning based on pointwise mutual information score.
#dependency LWP::Simple

use LWP::Simple;
use strict;
use warnings;

# if behind a proxy server set proxy here
#$ENV{HTTP_proxy} = "";

#get root output directory
my $rootDir = shift(@ARGV);
# get product category or name
my $category = shift(@ARGV);
# get threshold for pruning
my $threshold = shift(@ARGV);

# extract category hits
my $query = $category;
my $url = "http://api.search.live.net/xml.aspx?Appid=77CF4D29379231409431AA54F091A1C2C4B9C5B7&sources=web&query=" . $query;
#print "$url\n";
my $text = get($url);
#print $text;
$text =~ /<web:Total>(\d+)<\/web:Total>/gi;
my $categoryHits = $1;
print "\n$categoryHits";

opendir(DIR,"$rootDir/words") || die("cannot open directory \n");
my @files = readdir(DIR);
closedir(DIR);
# get feature pmi score
my %featureHits;
foreach my $file(@files) {
  unless( ($file eq ".") || ($file eq "..") ) {
    $query = $file;
    $query =~ s/\s/%20/gi;
    $url = "http://api.search.live.net/xml.aspx?Appid=77CF4D29379231409431AA54F091A1C2C4B9C5B7&sources=web&query=" . $query;
    #print "$url\n";
    $text = get($url);
    $text =~ /<web:Total>(\d+)<\/web:Total>/gi;
    my $featHits = $1;
    $query = "$category%20" . $query;  
    $url = "http://api.search.live.net/xml.aspx?Appid=77CF4D29379231409431AA54F091A1C2C4B9C5B7&sources=web&query=" . $query;
    $text = get($url);
    $text =~ /<web:Total>(\d+)<\/web:Total>/gi;
    my $featcatHits = $1;
    #print "$url\n";
    $featureHits{$file} = -1 * log (( $featcatHits/ ( $featHits * $categoryHits)));
    print "$file \t $featureHits{$file} \n";
  }
}

##TO-D0 apply pruning based on both frequency and pmi
# prune based on feature pmi score
while ( my ($key,$value) = each(%featureHits) )
{
  if($value > $threshold )
  {
    print "$key \t $value\n";
    unlink ("$rootDir/words/$key");
  }
}
