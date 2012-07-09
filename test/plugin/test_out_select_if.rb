require 'helper'

class SelectIfOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    select_if tag == "tag" or record["code"] == "200" or Time.at(time).sec == 0
    add_prefix prefix
  ]

  def create_driver(conf = CONFIG, tag='test.input')
    Fluent::Test::OutputTestDriver.new(Fluent::SelectIfOutput, tag).configure(conf)
  end

  def test_match_tag
    tag = 'tag' #match
    time = Time.local(2012, 10, 10, 10, 10, 10) #not match
    record = {'code' => '300'} #not match

    d1 = create_driver(CONFIG, tag)
    d1.run do
      d1.emit(record, time)
    end
    emits = d1.emits
    assert_equal 1, emits.length
    assert_equal ["prefix.#{tag}", time.to_i, record], emits[0]
  end

  def test_match_time
    tag = 'test.tag1' #not match
    time = Time.local(2012, 10, 10, 10, 10, 0) #match
    record = {'code' => '300'} #not match

    d1 = create_driver(CONFIG, tag)
    d1.run do
      d1.emit(record, time)
    end
    emits = d1.emits
    assert_equal 1, emits.length
    assert_equal ["prefix.#{tag}", time.to_i, record], emits[0]
  end


  def test_match_record
    tag = 'test.tag1' #not match
    time = Time.local(2012, 10, 10, 10, 10, 0) #not match
    record = {'code' => '200'} #match

    d1 = create_driver(CONFIG, tag)
    d1.run do
      d1.emit(record, time)
    end
    emits = d1.emits
    assert_equal 1, emits.length
    assert_equal ["prefix.#{tag}", time.to_i, record], emits[0]
  end

  def test_not_match
    tag = 'test.tag1'
    time = Time.now
    record = {'code' => '300'} #not match

    d1 = create_driver(CONFIG, tag)
    d1.run do
      d1.emit(record, time)
    end
    emits = d1.emits
    assert_equal 0, emits.length
  end

end
