# 
#      Perl module containing utilities for opinion mining 
#
#
# TO-DO  write proper documentation for each fucntion

use strict;
# dependencies
use Lingua::EN::Sentence qw( get_sentences add_acronyms );
use Lingua::EN::Tagger;

# reurns complete text of a file
sub getText {
  my $file = shift;
  open(FILE,"< $file");
  my $text = "";
  while(my $line = <FILE> ) {
    $text = $text . "\n" . $line;
  }
  return lc $text;
}

# returns sentences after sentence detection
sub getSentences {
  my $ref = shift;
  my $text = $$ref;
  add_acronyms("lt","gen");
  my $sentences = get_sentences($text);
  return $sentences;
}

# returns pos tagged text
sub posTags {
  my $ref = shift;
  my $text = $$ref;
  my $tag = new Lingua::EN::Tagger;
  my $taggedText = $tag->add_tags( $text );
  return $taggedText;
}

#returns all noun phrases
sub getNounPhrases {
  my @array;
  my $ref = shift;
  my $text = $$ref;
  while ($text =~ /<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1");
  }
  return @array; 
} 



#returns all base noun phrases
sub getBaseNounPhrases {
  my @array;
  my $ref = shift;
  my $text = $$ref;
  while ($text =~ /<DET>the<\/DET>\s+<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<DET>the<\/DET>\s+<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<DET>the<\/DET>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<DET>the<\/DET>\s+<JJ[RS]?>([\w\d]+)<\/JJ[RS]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<DET>the<\/DET>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<DET>the<\/DET>\s+<NN[SP]?>([\w\d]+)<\/NN[SP]?>/gi) {
    push(@array,"$1");
  }
  return @array; 
} 

#returns all definitive noun phrases
sub getDefinitiveNounPhrases {
  my @array;
  my $ref = shift;
  my $text = $$ref;
  while ($text =~ /<DET>the<\/DET>\s+<JJ>([\w\d]+)<\/JJ>\s+<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<DET>the<\/DET>\s+<JJ>([\w\d]+)<\/JJ>\s+<JJ>([\w\d]+)<\/JJ>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<DET>the<\/DET>\s+<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<DET>the<\/DET>\s+<JJ>([\w\d]+)<\/JJ>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<DET>the<\/DET>\s+<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<DET>the<\/DET>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1");
  }
  return @array; 
} 

sub getDefNounPhrases {
  my @array;
  my $ref = shift;
  my $text = $$ref;
  while ($text =~ /<JJ>([\w\d]+)<\/JJ>\s+<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<JJ>([\w\d]+)<\/JJ>\s+<JJ>([\w\d]+)<\/JJ>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2 $3");
  }
  while ($text =~ /<JJ>([\w\d]+)<\/JJ>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<NN>([\w\d]+)<\/NN>\s+<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1 $2");
  }
  while ($text =~ /<NN>([\w\d]+)<\/NN>.+<VB[DGNPZ]?>/gi) {
    push(@array,"$1");
  }
  return @array; 
} 



1;
