hn_dupesum
==========

A quickie Ruby script to generate a list of HackerNews dupe submissions.

This was inspired by [user ColinWright's diligence in pointing out duped-and-previously-discussed discussions](https://news.ycombinator.com/item?id=7796382). Dupes aren't necessarily bad, so this tool's intended use is to quickly find possible previous submissions and produce a HN-friendly aggregated list, so that readers can see what's been previously said.

This obviously is a bare-bones tool, without even proper configuration flags, meant to serve as a simple helper for anyone wanting to list past HN discussions. It wouldn't be very difficult to do something like filter the results list for similar URLs (the [HN-Algolia search API](https://hn.algolia.com/api) only lets you query by search term) so that only true-dupes are selected.



A typical[summary-of-dupes comment](https://news.ycombinator.com/item?id=7796382) looks like this: 

``` markdown
In case you're wondering why this obviously brilliant article doesn't get much discussion, or many votes, some people here have seen it before. Here are some of the previous submissions:
https://hn.algolia.com/?q=brief+incomplete#!/story/forever/p...
Of course, it may again get lots of discussion and lots of up-votes. We'll see.
https://news.ycombinator.com/item?id=7263243
https://news.ycombinator.com/item?id=7149634
https://news.ycombinator.com/item?id=6953863
https://news.ycombinator.com/item?id=6504217
https://news.ycombinator.com/item?id=6234361
https://news.ycombinator.com/item?id=5804668
https://news.ycombinator.com/item?id=5728844
https://news.ycombinator.com/item?id=5728843
https://news.ycombinator.com/item?id=5695816
https://news.ycombinator.com/item?id=5377944
https://news.ycombinator.com/item?id=5129062
https://news.ycombinator.com/item?id=4586462
https://news.ycombinator.com/item?id=3507566
https://news.ycombinator.com/item?id=3503896
https://news.ycombinator.com/item?id=1475826
https://news.ycombinator.com/item?id=1327746
https://news.ycombinator.com/item?id=1310127
https://news.ycombinator.com/item?id=599164
```

The `hn_dupesum` tool merely automates the searching of the story title and producing the list of dupes, including top comments in the previous discussions:

```
# ============================
# Stories containing the title of "a brief history of programming" received:
# - At least 3 submissions from 2009-05-08 to 2013-05-12, i.e. ~614 days between each submission
# - At least 897 points, i.e. ~299.0 points per submission
# - At least 92 comments, i.e. ~30.7 comments per submission
# ============================


# Submission #1 by DanielRibeiro: https://news.ycombinator.com/item?id=3503896
# 2012-01-24 (~852 days ago)
# 389 points and 45 comments
# Top comments:
# -  bitops [27 points]: *Only two minor quibbles: 1) did not mention Clojure. 2) broke the amusing narrative a bit in the middle by including a true story (Perl). Really funny otherwise.* [https://news.ycombinator.com/item?id=3504001]
# -  f4stjack [26 points]: *"1996 - James Gosling invents Java. Java is a relatively verbose, garbage collected, class based, statically typed, single dispatch, object oriented language with single implementation inheritance and multiple interface inheritance. Sun loudly heralds Java's novelty. 2001 - Anders Hejlsberg invents C#. C# is a relatively verbose, garbage collected, class based, statically typed, single dispatch, object oriented language with single implementation inheritance and multiple interface inheritance. ...* [https://news.ycombinator.com/item?id=3503969]
# -  perfunctory [24 points]: *My favourite is actually: 1972 - Dennis Ritchie invents a powerful gun that shoots both forward and backward simultaneously. Not satisfied with the number of deaths and permanent maimings from that invention he invents C and Unix.* [https://news.ycombinator.com/item?id=3504067]
```




## Installation

I wrote this on my Ruby 2.0 machine but it doesn't use anything outside of Ruby's stdlib. I had hoped to do it via bash script only but my shell skills are weak.

Just download [hn_dupesum.rb]

## Usage

Pass in a single argument, ideally, the title of a submission:

    $ ruby hn_dupesum.rb "a brief history of programming languages"

...or if you prefer to `chmod` it:

    $ chmod +x hn_dupesum.rb
    $ ./hn_dupesum.rb "a brief history of programming languages"`

Currently, it's just a quickie hack and doesn't support any command-line flags like a proper UNIX tool.

#### Sample output

This produces a list that is meant for HN's limited formatting options. The use-case is that someone like ColinWright can just paste it directly into a comment form.

```
# ============================
# Stories containing the title of "a brief history of programming" received:
# - At least 3 submissions from 2009-05-08 to 2013-05-12, i.e. ~614 days between each submission
# - At least 897 points, i.e. ~299.0 points per submission
# - At least 92 comments, i.e. ~30.7 comments per submission
# ============================


# Submission #1 by DanielRibeiro: https://news.ycombinator.com/item?id=3503896
# 2012-01-24 (~852 days ago)
# 389 points and 45 comments
# Top comments:
# -  bitops [27 points]: *Only two minor quibbles: 1) did not mention Clojure. 2) broke the amusing narrative a bit in the middle by including a true story (Perl). Really funny otherwise.* [https://news.ycombinator.com/item?id=3504001]
# -  f4stjack [26 points]: *"1996 - James Gosling invents Java. Java is a relatively verbose, garbage collected, class based, statically typed, single dispatch, object oriented language with single implementation inheritance and multiple interface inheritance. Sun loudly heralds Java's novelty. 2001 - Anders Hejlsberg invents C#. C# is a relatively verbose, garbage collected, class based, statically typed, single dispatch, object oriented language with single implementation inheritance and multiple interface inheritance. ...* [https://news.ycombinator.com/item?id=3503969]
# -  perfunctory [24 points]: *My favourite is actually: 1972 - Dennis Ritchie invents a powerful gun that shoots both forward and backward simultaneously. Not satisfied with the number of deaths and permanent maimings from that invention he invents C and Unix.* [https://news.ycombinator.com/item?id=3504067]

# Submission #2 by toddc: https://news.ycombinator.com/item?id=599164
# 2009-05-08 (~1844 days ago)
# 299 points and 14 comments
# Top comments:
# -  tumult [52 points]: *Lambdas are relegated to relative obscurity until Java makes them popular by not having them. Alright, this was surprisingly amusing. Thanks.* [https://news.ycombinator.com/item?id=599281]
# -  jfarmer [33 points]: *My favorite:\n1972 - Dennis Ritchie invents a powerful gun that shoots both forward and backward simultaneously. Not satisfied with the number of deaths and permanent maimings from that invention he invents C and Unix.* [https://news.ycombinator.com/item?id=599308]
# -  visitor4rmindia [17 points]: *Oh my God! That was the best belly laugh I've had in a long time. Very fun read. &#62; 1995 - Brendan Eich reads up on every mistake ever made in designing a programming language, invents a few more, and creates LiveScript. Later, in an effort to cash in on the popularity of Java the language is renamed JavaScript. Later stil, in an effort to cash in on the popularity of skin diseases the language is renamed ECMAScript.* [https://news.ycombinator.com/item?id=599345]

# Submission #3 by ldubinets: https://news.ycombinator.com/item?id=5695816
# 2013-05-12 (~378 days ago)
# 209 points and 33 comments
# Top comments:
# -  ldubinets [26 points]: *It took me a couple minutes too... The first comment sorts it out though. Turns out that Jacquard's loom was multi-threaded after all.* [https://news.ycombinator.com/item?id=5697144]
# -  mercuryrising [17 points]: *I like this. I like this a lot. I think far too often people take the concepts we study too seriously. Things get challenging, things get precise, but the moment the humor leaves, the creativity is gone. Think of how easy it would be to learn something if you make a joke every 5 minutes while learning it (about the subject). In your mind, you turned this abstract concept into something else, something funny, something with pathways and connections that weren't expected. You manipulated it, chan...* [https://news.ycombinator.com/item?id=5696773]
# -  Symmetry [17 points]: *Reminds me of C being described as "a language that combines all the elegance and power of assembly language with all the readability and maintainability of assembly language".* [https://news.ycombinator.com/item?id=5696368]

```


(This is obviously not a very broad use-case so you can modify the script to output JSON instead.)



### How it works

It simply uses the [Algolia search API that powers HN's official search](https://hn.algolia.com/api). First, it does a "relavance-priority" search for the story title terms:

https://hn.algolia.com/api/v1/search?tags=story&query=a%20brief%20history%20of%20programming

Then for each submission, it looks for the top-upvoted comments:

Fetching top comments via https://hn.algolia.com/api/v1/search?tags=comment,story_3503896 


Note that Algolia has a rate-limit (10,000 per hour per IP) and my script doesn't have any command-line options to configure what is collected. By default (i.e. because I'm lazy), my script just gets the first page of matched results and then gets the first page of comments...so if a query brings back 20 submissions, you'll be making as many as 21 calls to the API (1 for the story search, 20 for each of the story submissions' comments page). Obviously you can just edit the script to your liking.

Feel free to fork and make it a real command-line tool. Comments can be tweeted to [@dancow](https://twitter.com/dancow)

