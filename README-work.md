# Raku-Lingua-StopwordsISO

## In brief

This is a Raku package for stop words of different languages. 
Follows 
["Stopwords ISO" project](https://github.com/stopwords-iso), [GDr1],
and Raku package 
["Lingua::Stopwords"](https://raku.land/cpan:CHSANCH/Lingua::Stopwords), [CSp1].

This package has the stop words JSON data file
["stopwords-iso.json"](https://github.com/stopwords-iso/stopwords-iso/blob/master/stopwords-iso.json),
from [GDr1] as a resource file.   

------

## Usage examples

The function `stopwords-iso` takes as an argument a language spec (e.g. 'en' or 'English') and 
returns a `SetHash`:

```perl6
use Lingua::StopwordsISO;

"I Want You To Deal With Your Problems By Becoming Rich!"
        .words
        .map({ $_.lc => $_.lc ∈ stopwords-iso('English')})
```

The function `delete-stopwords` deletes the stop words in a string:

```perl6
delete-stopwords(
        'What fun is there in making plans, 
acquiring discipline in organizing thoughts, 
devoting attention to detail, 
and learning to be self-critical?', 'en')
```

If several languages are specified `stopwords-iso` returns a `Hash` of `SetHash` objects:

```perl6
stopwords-iso(<Bulgarian Czech English Russian Spanish>)>>.elems
```

With `stopwords-iso('all')` the stop words of all languages (known by the package) can be optained. 

------

## Potential problems

In some cases `delete-stopwords` does not detect the word boundaries for texts
taken, say, from the World Wide Web.
 
This text "works":

```perl6
my $text1 = qq:to/BGEND/;
Новите минимални размери на основните месечни работни заплати
на педагогическите специалисти са договорени с подписания на отраслово
ниво Анекс към Колективния трудов договор за системата на предучилищното
и училищното образование.
BGEND

say delete-stopwords($text1, 'bg');
```

This does not:

```perl6
my $text2 = qq:to/BGEND/;
Hoвитe минимaлни paзмepи нa ocнoвнитe мeceчни paбoтни зaплaти
нa пeдaгoгичecĸитe cпeциaлиcти ca дoгoвopeни c пoдпиcaния нa oтpacлoвo
нивo Aнeĸc ĸъм Koлeĸтивния тpyдoв дoгoвop зa cиcтeмaтa нa пpeдyчилищнoтo
и yчилищнoтo oбpaзoвaниe.
BGEND

say delete-stopwords($text2, 'bg');
```

------

## References

[GDr1] Gene Diaz,
[Stopwords ISO project](https://github.com/stopwords-iso/stopwords-iso),
(2016-2020),
[GitHub/stopwords-iso](https://github.com/stopwords-iso).

[CSp1] Christian Sánchez,
[Lingua::Stopwords Raku package](https://raku.land/cpan:CHSANCH/Lingua::Stopwords),
(2018),
[Raku Land](https://raku.land).