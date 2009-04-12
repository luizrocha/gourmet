require 'alphabar'
ActiveRecord::Base.extend Alphabar::AlphaFind
ActionView::Base.send :include, Alphabar::Helper