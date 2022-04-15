#!/usr/bin/env raku
use v6.d;

use Lingua::StopwordsISO;

say stopwords-iso('BG');

say stopwords-iso('Bulgarian');

say stopwords-iso(<ru bg pl>);

say stopwords-iso(<Bulgarian English>);

say stopwords-iso('all')>>.elems;
