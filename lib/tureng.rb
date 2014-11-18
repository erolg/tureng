require "tureng/version"

require 'nokogiri'
require 'open-uri'
require 'text-table'

class Tureng
  def initialize(w, u = "http://tureng.com/search/")
    @word, @url = w, u
    get_response
  end

  def get_response
    uri = @url + URI::encode(@word)
    @response = Nokogiri::HTML(open("#{uri}"), nil, 'utf-8')
  end

  def draw_results(params)
    source = @response.css("table[id='#{params}ResultsTable']")
    return if source.empty?

    # draw an empty table
    table = Text::Table.new :horizontal_padding    => 1,
                            :vertical_boundary     => '=',
                            :horizontal_boundary   => '|',
                            :boundary_intersection => 'O'

    # parse table headings
    headings = source.css('th')

    # add headings to table
    table.head = ["##","#{headings[1].text}", "#{headings[3].text}", "#{headings[4].text}"]

    # parse and count translation results
    tr_tags = source.css("tr")
    size_of_tr_tags = tr_tags.size - 1 # -1 is for th tags

    # fill table with results
    for i in 1..size_of_tr_tags
      translations = tr_tags[i].css("td")
      table.rows << [["#{translations[0].text}", "#{translations[1].text}", "#{translations[3].text}", "#{translations[4].text}"]]
    end

    # draw table
    table.to_s
  end

  def get_suggestions
    suggestion_size = @response.css("li a").size

    # draw suggestions table
    table = Text::Table.new
    table.head = [" Öneriler "]

    # fill table with suggestions
    for i in 1..(suggestion_size - 1)
      table.rows << @response.css("li a")[i].text
    end

    # draw table
    table.to_s
  end

  def draw_all_results
    status = @response.css("h1")[1].text.strip
    output = []
    if status == "Did you mean that?"
      output << "Aradığınız kelime bulunamadı. Bunlardan birini yazmak istemiş olabilir misiniz?"
      output << get_suggestions
    elsif status == "Term not found"
      output << "Aradığınız kelime bulunamadı."
    else
      output << draw_results('turkish')
      output << draw_results('turkishFull')
      output << draw_results('english')
      output << draw_results('englishFull')
    end
    output.join("\n")
  end
end
