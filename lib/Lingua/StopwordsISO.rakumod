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
            return %stopwords-iso{$_}.SetHash;
        }

        when (%language-to-iso-abbr{$_}:exists) && (%stopwords-iso{%language-to-iso-abbr{$_}:exists}) {
            return %stopwords-iso{%language-to-iso-abbr{$_}}.SetHash;
        }

        default {
            warn "Unknown language spec: $lang";
            return Nil;
        }
    }
}


#----------------------------------------------------------

%stopwords-iso = BEGIN {
    JSON::Fast::from-json(slurp(%?RESOURCES<stopwords-iso.json>))
}

%language-to-iso-abbr = BEGIN {
    my %res = JSON::Fast::from-json(slurp(%?RESOURCES<language-to-iso-abbr.json>));
    %res.map({ $_.key.lc => $_.value.lc }).Hash
}