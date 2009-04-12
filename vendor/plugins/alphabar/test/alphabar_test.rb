$:.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'cgi'

class AlphabarTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  include Alphabar::Helper

  attr_accessor :params

  def setup
    @controller = self
    self.params = {}

    @users, @paginator = MockUser.alpha_find :last_name, 'B', :order => 'last_name'
  end

  def test_paginator

    assert_equal ['bob', 'bubba'], @users
    assert_equal 3, @paginator.count('a')
    assert_equal 5, @paginator.count('b')
    assert_equal 0, @paginator.count('c')
    assert_equal 4, @paginator.count('m')
    assert_equal 0, @paginator.count('n')
    assert_equal 12, @paginator.count('z')

    assert_equal [:all, {:group => 'SUBSTR(LOWER(last_name), 1, 1)'}], MockUser.count_args
    assert_equal [:all], MockUser.find_args
    assert_equal [{:find => {:conditions => ["users.last_name LIKE ?", 'B%']}}], MockUser.with_scope_args
  end

  def test_helper
    assert_equal '<a href="?ltr=A">A</a> <a href="?ltr=B" class="current">B</a> C D E F G H I J K L <a href="?ltr=M">M</a> N O P Q R S T U V W X Y <a href="?ltr=Z">Z</a>', alphabar(@paginator)
  end

  def test_helper_collapse
    @paginator.instance_variable_set("@counts", HashWithIndifferentAccess['b' => 2])
    assert_equal '', alphabar(@paginator)
  end

  # Simulate url_for so link_to works
  def url_for(options)
    '?' + options.collect do |key, value|
      "#{key}=#{CGI.escape value}"
    end.join('&')
  end

  # Stubs for image_tag to work
  def request; self end
  def relative_url_root; '' end
end

# We just want to simulate the parts of ActiveRecord that we need. We
# don't want all the trouble of having a test database. We should
# probably use FlexMock for something like this but I created this
# before I knew about FlexMock
class MockUser
  extend Alphabar::AlphaFind
  cattr_accessor :count_args, :find_args, :with_scope_args

  def self.find(*args)
    self.find_args = args
    ['bob', 'bubba']
  end

  def self.count(*args)
    self.count_args = args
    [
      ['a', 3],
      ['b', 5],
      ['m', 4],
      ['z', 12]
    ]
  end
  def self.table_name
    'users'
  end
  def self.with_scope(*args)
    self.with_scope_args = args
    yield
  end
end