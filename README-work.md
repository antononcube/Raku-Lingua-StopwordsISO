# Raku-Lingua-StopwordsISO

## In brief

This is a Raku package for stop words of different languages. 
Follows 
["Stopwords ISO" project](https://github.com/stopwords-iso), [GDr1],
and Raku package 
["Lingua::Stopwords"](https://raku.land/cpan:CHSANCH/Lingua::Stopwords), [CSp1].

This package has the JSON file
["stopwords-iso.json"](https://github.com/stopwords-iso/stopwords-iso/blob/master/stopwords-iso.json)
from [GDr1] as a resource file.   

------

## Usage examples

### `stopwords-iso`

The function `stopwords-iso` takes as an argument a language spec (e.g. 'en' or 'English') and 
returns a `SetHash`:

```perl6
use Lingua::StopwordsISO;

"I Want You To Deal With Your Problems By Becoming Rich!"
        .words
        .map({ $_.lc => $_.lc ∈ stopwords-iso('English')})
```

If several languages are specified then the result is a `Hash` of `SetHash` objects:

```perl6
stopwords-iso(<Bulgarian Czech English Russian Spanish>)>>.elems
```

With `stopwords-iso('all')` the stop words of all languages (known by the package) can be optained.

### `delete-stopwords`

The function `delete-stopwords` deletes the stop words in a string:

```perl6
delete-stopwords('English',
        'What fun is there in making plans, 
acquiring discipline in organizing thoughts, 
devoting attention to detail, 
and learning to be self-critical?')
```

The first, language spec argument can be a word ('English', 'Russian', 'Spanish', etc.)
or an abbreviation ('en', 'ru', 'es', etc.)  

If only one argument is given to `delete-stopwords` then the language spec is 'English'.

------

## Command Line Interface (CLI)

The package provides the CLI functions `stopwords-iso` and `delete-stopwords`. 

### `stopwords-iso`

Here is the usage message of `stopwords-iso`:

```shell
> stopwords-iso --help
Usage:
  stopwords-iso [-f|--format=<Str>] [<langs> ...] -- Gives stop words for the specified languages in the specified format.
  stopwords-iso [-f|--format=<Str>] -- Gives stop words for language specs in (pipeline) input.
  
    [<langs> ...]        Languages to get the stop words for.
    -f|--format=<Str>    Output format one of 'text', 'json', or 'raku'. [default: 'text']
```
Here are example shell commands:

```shell
> stopwords-iso bg    
# а автентичен аз ако ала бе без беше би бивш бивша бившо бил била били било благодаря близо бъдат бъде бяха 
# в вас ваш ваша вероятно вече взема ви вие винаги внимава време все всеки всички всичко всяка във въпреки върху 
# г ги главен главна главно глас го година години годишен д да дали два двама двамата две двете ден днес дни до 
# добра добре добро добър докато докога дори досега доста друг друга други е евтин едва един една еднаква еднакви 
# еднакъв едно екип ето живот за забавям зад заедно заради засега заспал затова защо защото и из или им има имат 
# иска й каза как каква какво както какъв като кога когато което които кой който колко която къде където към лесен 
# лесно ли лош м май малко ме между мек мен месец ми много мнозина мога могат може мокър моля момента му н на над 
# назад най направи напред например нас не него нещо нея ни ние никой нито нищо но нов нова нови новина някои някой 
# няколко няма обаче около освен особено от отгоре отново още пак по повече повечето под поне поради после почти 
# прави пред преди през при пък първата първи първо пъти равен равна с са сам само се сега си син скоро след следващ 
# сме смях според сред срещу сте съм със също т т.н. тази така такива такъв там твой те тези ти то това тогава този 
# той толкова точно три трябва тук тъй тя тях у утре харесва хиляди ч часа че често чрез ще щом юмрук я як
```

```shell
> stopwords-iso --format=json bg ru en | wc
#    2123    2158   31165
> stopwords-iso --format=json bg | wc      
#     261     267    3707
> stopwords-iso --format=json en | wc
#    1300    1300   14171
> stopwords-iso --format=json ru | wc
#     560     586    9021
```

### `delete-stopwords`

Here is the usage message of `delete-stopwords`:

```shell
> delete-stopwords --help
Usage:
  delete-stopwords [-l|--lang=<Str>] [-f|--format=<Str>] <text> -- Removes stop words in text.
  delete-stopwords [-l|--lang=<Str>] [-f|--format=<Str>] [<words> ...] -- Removes stop words from a list of words.
  delete-stopwords [-l|--lang=<Str>] [-f|--format=<Str>] -- Removes stop words in (pipeline) input.
  
    <text>               Text to remove stop words from.
    -l|--lang=<Str>      Language [default: 'English']
    -f|--format=<Str>    Output format one of 'text', 'lines', or 'raku'. [default: 'text']
    [<words> ...]        Text to remove stop words from.

```

Here are example shell commands:

```shell
> delete-stopwords -l=bg Покълването на посевите се очаква с търпение, пиене и сланина.
# Покълването  посевите  очаква  търпение, пиене  сланина.
```

```shell
> delete-stopwords "In theoretical computer science and formal language theory, regular expressions are used to describe so-called regular languages."
# theoretical  science  formal language theory, regular expressions     so-called regular languages.
```

```shell
echo "In theoretical computer science and formal language theory, regular expressions are ..." | xargs -n1 | delete-stopwords
# theoretical  science  formal language theory, regular expressions  ...
```
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

say delete-stopwords('bg', $text1);
```

This does not:

```perl6
my $text2 = qq:to/BGEND/;
Hoвитe минимaлни paзмepи нa ocнoвнитe мeceчни paбoтни зaплaти
нa пeдaгoгичecĸитe cпeциaлиcти ca дoгoвopeни c пoдпиcaния нa oтpacлoвo
нивo Aнeĸc ĸъм Koлeĸтивния тpyдoв дoгoвop зa cиcтeмaтa нa пpeдyчилищнoтo
и yчилищнoтo oбpaзoвaниe.
BGEND

say delete-stopwords('bg', $text2);
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