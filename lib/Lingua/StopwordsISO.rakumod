use v6.d;

use JSON::Fast;

unit module Lingua::StopwordsISO;

my %stopwords-iso;
my %language-to-iso-abbr;

#| Give stop words for a language specification.
#| C<$langSpec> can be a string or a list of strings.
proto stopwords-iso($langSpec) is export {*}

multi stopwords-iso(Str $lang where $_.lc eq 'all' --> Hash) {
    return %stopwords-iso>>.SetHash;
}

multi stopwords-iso(@langs --> Hash) {
    return @langs.map({ $_ => stopwords-iso($_) }).Hash;
}

multi stopwords-iso(Str $lang --> SetHash) {
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
#| C<$langSpec> is a language spec.
#| C<$textSpec> can be a string or a list of strings.
proto delete-stopwords(|) is export {*}

multi delete-stopwords(@texts --> Positional) {
    return delete-stopwords('English', @texts);
}

multi delete-stopwords(Str $lang, @texts --> Positional) {
    return @texts.map({ delete-stopwords($lang, $_) });
}

multi delete-stopwords(Str $lang, Str $text --> Str) {
    my %sws = stopwords-iso($lang);
    my $text2 = $text.subst(:g, / <?after [\s+ | <punct> && <:!Pd>]> (\w+) <?before [\s+ | <punct> && <:!Pd>]> <?{ $0.Str.lc (elem) %sws }> /, '')
            .subst(/ ^^  (\w+)  <?before [\s+ | <punct> && <:!Pd>]> <?{ $0.Str.lc (elem) %sws }> /, '')
            .subst(/ <?after [\s+ | <punct> && <:!Pd>]> (\w+) $$ <?{ $0.Str.lc (elem) %sws }> /, '');
    return $text2;
}

multi delete-stopwords(Str $text --> Str) {
    return delete-stopwords('English', $text);
}

#----------------------------------------------------------

%stopwords-iso = BEGIN {
    JSON::Fast::from-json(slurp(%?RESOURCES<stopwords-iso.json>))
}

%language-to-iso-abbr = BEGIN {
    my %res = JSON::Fast::from-json(slurp(%?RESOURCES<language-to-iso-abbr.json>));
    %res.map({ $_.key.lc => $_.value.lc }).Hash
}