#!/usr/bin/perl
#
#               This Script currently do sentence detection and extracts noun phrases using a lib for english language text.
#                           Currently works on files in a directory. If a dirctory has a directory it fails 
#
# dependencies are util.pm

use strict;
use warnings;
use util;

# get the directory name from command line argument.

my $dirname = shift(@ARGV);
opendir(DIR,$dirname) || die("cannot open directory \n");
# get root output directory
my $rootDir = shift(@ARGV);

# open directory and read all names . will fail if a directory contains another directory

my @files = readdir(DIR);
closedir(DIR);

# process each file

foreach my $file(@files) {
  unless( ($file eq ".") || ($file eq "..") ) {

    #call routine for text concatenation .. will return complete text in file in one variable.
    my $text = getText("$dirname/$file");
    # change multiple dots to single
    $text =~ s/\.+/./gi;
    # pass the text to sentence detector .. will return reference to array of sentences.
    my $sentences = getSentences(\$text);
    my @nounPhrases;
    foreach my $sentence(@$sentences) {
      # pass reference of each sentence to pos tag finding routine
      my $tagged = posTags(\$sentence);
      # print "$tagged\n";
      # extracting base noun phrases and storing in an array
      #my @nounPh = getBaseNounPhrases(\$tagged);
      my @nounPh = getNounPhrases(\$tagged);
      push(@nounPhrases,@nounPh);
    }
    # writing to a file all features will be written in a single file format < nounphrase    filename >
    open(FILE,">> $rootDir/features.fs") || die("cannot open ");
    foreach my $np(@nounPhrases) {
      print FILE "$np------$file\n";
    }
    close(FILE);
  }
}
#### can be made fast if write feature directly to file above this

# conbine into files named after phrases that will contain the names of file in which they appear
`mkdir $rootDir/words`;
open (FT,"<$rootDir/features.fs") || die("cannot open ");
while ( my $word = <FT> ) {
  my ($nounword,$fname) = split(/------/,$word);
  open(WD,">> $rootDir/words/$nounword");
  print WD "$fname";
  close(WD);
}
close (FT);
print "done extracting np";

#done preprocessing ..

# time to rate features.






