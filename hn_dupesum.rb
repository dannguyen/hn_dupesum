#!/usr/bin/ruby

# Tested on Ruby 2.0
#
# usage:

# $ chmod +x hn_dupesum.rb
# $ ./hn_dupesum.rb "a brief history of programming languages"

# sample response:
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



require 'open-uri'
require 'json'
require "stringio"


BASE_HN_ITEM_URL = 'https://news.ycombinator.com/item?id='
BASE_HN_API_SEARCH_URL="https://hn.algolia.com/api/v1/search"
BASE_HN_API_COMMENTS_URL="https://hn.algolia.com/api/v1/search?tags=comment,story_"

the_query = ARGV[0] # TODO: make actual command line tool
results_count = 0 # TODO: make this a flag
top_comment_count = 3 # TODO: make this a flag
is_verbose = true # TODO: make this a flag
logger = is_verbose ? STDOUT : StringIO.new

# TODO add option for regular JSON output

# build the query
url = URI.parse(BASE_HN_API_SEARCH_URL)
url.query = "tags=story&query=#{URI.escape the_query}"

# fetch the search results, extract the 'hits', and sort by 'points' descending
logger.puts "Fetching from #{url}"
hits = open(url.to_s){ |f| JSON.parse( f.read )['hits'] }.sort_by{|h| -h['points'].to_i }
logger.puts "#{hits.count} hits found"


hits = hits[0..(results_count-1)].map do |hit|
  # extract the relevant attributes
  hsh = %w(author created_at_i num_comments objectID points title url).reduce({}){|h, k| h[k] = hit[k]; h}
  # format the date element
  date_created = Time.at(hit['created_at_i'].to_i)

  # merge an empty comments array and new date attributes
  hsh.merge!( { 'comments' => [],
    'date' => date_created.strftime("%Y-%m-%d"),
    'days_ago' => ((Time.now - date_created) / (60 * 60 * 24)).round,
    'hn_url' => "#{BASE_HN_ITEM_URL}#{hsh['objectID']}"
    })

  # fetch comments
  if hsh['num_comments'].to_i > 0
    begin
      # by default, comments are sorted by points in descending order
      comment_url = "#{BASE_HN_API_COMMENTS_URL}#{hsh['objectID']}"
      logger.puts "Fetching top comments via #{comment_url} "
      comment_hits = open(comment_url){|f| JSON.parse f.read }['hits']
    rescue => err
      logger.puts err
      logger.puts "Skipping comments fetching because of error..."
    else
      # now, lets fetch the top comments
      comment_hits[0..(top_comment_count-1)].each do |c|
        comment = {
            'author' => c['author'],
            'comment_text' => c['comment_text'].length > 500 ? c['comment_text'][0..500] << '...' : c['comment_text'],
            'points' => c['points'],
            'hn_url' => "#{BASE_HN_ITEM_URL}#{c['objectID']}",
            'objectID' => c['objectID'],
          }
        # strip out simple tags and excess space
        comment['comment_text'] = comment['comment_text'].gsub(/\<\/?(?:p|i|pre|code|a|a href=".+?" rel="nofollow")\>/, ' ').gsub(/\s+/, ' ').strip

        hsh['comments']  << comment
      end
    end
  end

  hsh
end

############################
## print out in HN pretty format
puts "\n", "============================"
puts "Stories containing the title of \"#{the_query}\" received: "

_dsort = hits.sort_by{|h| h['days_ago'] }
newhit  = _dsort[0]
oldhit = _dsort[-1]


puts "- At least #{hits.count} submissions from #{oldhit['date']} to #{newhit['date']}, i.e. ~#{oldhit['days_ago'] / hits.count} days between each submission"

total_points = hits.inject(0){|s,h| s += h['points'].to_i }
puts "- At least #{total_points} points, i.e. ~#{(total_points / hits.count.to_f).round(1)} points per submission"

total_comments = hits.inject(0){|s,h| s += h['num_comments'].to_i }
puts "- At least #{total_comments} comments, i.e. ~#{(total_comments / hits.count.to_f).round(1)} comments per submission"
puts "============================", "\n"

hits.each_with_index do |hit, idx|
  puts "\n"
  puts "Submission ##{idx + 1} by #{hit['author']}: #{hit['hn_url']}"
  puts "#{hit['date']} (~#{hit['days_ago']} days ago)", "#{hit['points']} points and #{hit['num_comments']} comments"

  unless hit['comments'].empty?
    puts "Top comments:"
    hit['comments'].each do |comment|
      puts "-  #{comment['author']} [#{comment['points']} points]: *#{comment['comment_text']}* [#{comment['hn_url']}]"
    end
  end
end
