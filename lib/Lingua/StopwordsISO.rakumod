use v6.d;

use JSON::Fast;

unit module Lingua::StopwordsISO;

my %stopwords-iso;
my %language-to-iso-abbr;

#| Give stop words for a language specification.
#| C<$langSpec> can be a string or a list of strings.
proto stopwords-iso( $langSpec ) is export {*}

multi stopwords-iso( Str $lang where $_.lc eq 'all' --> Hash) {
    return %stopwords-iso>>.SetHash;
}

multi stopwords-iso( @langs --> Hash) {
    return @langs.map({ $_ => stopwords-iso( $_ ) }).Hash;
}

multi stopwords-iso( Str $lang --> SetHash) {
    given $lang.lc {
        when %stopwords-iso{$_}:exists {
            return %stopwords-iso{$_}.clone.SetHash;
        }

        when (%language-to-iso-abbr{$_}:exists) && (%stopwords-iso{%language-to-iso-abbr{$_}:exists}) {
            return %stopwords-iso{%language-to-iso-abbr{$_}}.clone.SetHash;
        }

        default {
            warn "Unknown language spec: $lang";
            return Nil;
        }
    }
}


#----------------------------------------------------------
#| Delete stop words for given text(s) and a language specification.
#| C<$textSpec> can be a string or a list of strings.
#| C<$langSpec> is a language spec.
proto delete-stopwords( $textSpec, $langSpec ) is export {*}

multi delete-stopwords( @texts, Str $lang --> Positional) {
    return @texts.map({ delete-stopwords($_, $lang) });
}

multi delete-stopwords( Str $text, Str $lang = 'English' --> Str) {
    my %sws = stopwords-iso($lang);
    my $text2 = $text.subst( / <wb> (\w+) <wb> <?{ $0.Str.lc (elem) %sws }> /, '' ):g;
    return $text2;
}


#----------------------------------------------------------

%stopwords-iso = BEGIN {
    JSON::Fast::from-json(slurp(%?RESOURCES<stopwords-iso.json>))
}

%language-to-iso-abbr = BEGIN {
    my %res = JSON::Fast::from-json(slurp(%?RESOURCES<language-to-iso-abbr.json>));
    %res.map({ $_.key.lc => $_.value.lc }).Hash
}