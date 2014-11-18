require 'minitest/autorun'
require 'tureng'

class TurengTest < Minitest::Test
  def setup
    @result_turkish = Tureng.new("hello")
    @result_english = Tureng.new("merhaba")
  end

  def test_response
    assert_instance_of Nokogiri::HTML::Document, @result_turkish.get_response
    assert_instance_of Nokogiri::HTML::Document, @result_english.get_response
  end
  
  def test_turkish
    result = @result_turkish.draw_results('english')
    assert_match /| Common Usage | hello   | merhaba    |/, result
    assert_match /| General      | hello   | selam      |/, result
  end
  
  def test_english
    result = @result_english.draw_results('turkish')
    assert_match /| Common Usage | merhaba | hello       |/, result
    assert_match /| General      | merhaba | hello       |/, result
  end
  
  def test_did_you_mean_that
    result = Tureng.new("asasde").draw_all_results
    assert_match /Aradığınız kelime bulunamadı./, result
    assert_match /Bunlardan birini yazmak istemiş olabilir misiniz\?/, result
    assert_match /|  Öneriler  |/, result
    assert_match /| asabe      |/, result
  end
  
  def test_term_not_found
    result = Tureng.new("dxsxmk").draw_all_results
    assert_match /Aradığınız kelime bulunamadı./, result
  end
end