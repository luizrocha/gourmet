# The Alphabar object is similar to the paginator object that used to
# be in Rails. It keeps track of all the meta-data about the desired
# behavior and executes the searches in the most optimal way. This
# object can be used in the controller like the following:
#
#   @user_paginator = Alphabar.new
#   @user_paginator.field = :last_name
#   @user_paginator.group = params[:ltr]
#   @users = @user_paginator.find(User, :order => 'last_name')
#
# See Alphabar::AlphaFind to reduce the amount of
# code in your controller for the common case.
class Alphabar

  # The current group being searched on that the results should be
  # returned for. Currently this should be a letter A-Z or 'Blank' but
  # eventually we might support different types of alphabars such
  # as those that group several letters under one page or those that
  # split a single letter into multiple pages. This is why we use
  # the terminology "group" instead of "letter"
  attr_accessor :group

  # The field used to divide the objects into the different groups (letters)
  attr_accessor :field

  # Will return the minimum number of records that must exist before
  # an alphabar will display. Set this through the options given
  # to the Alphabar object. This accessor mainly exists so a helper
  # can read it to determine if it should display the bar.
  attr_reader :min_records

  # Create a new alphabar to execute a letter based search. The options
  # are:
  #
  #   :all::
  #     Boolean to indicate if an 'All' group should be available
  #   :min_records::
  #     The minimum number of records that must exist before the
  #     alphabar will actually show up. This will prevent a mostly
  #     empty bar in the case of sparse data.
  #      
  def initialize(options={})
    @options = options
  end

  # Will execute the actual search on the given model. There is
  # currently no way to apply conditions except through with_scope.
  def find(model)

    # Find out how many are in each bucket
    # FIXME: This may be databse specific. Works on MySQL and SQLite
    # FIXME: field should be sanatized. Possible SQL Injection attack
    @counts = model.count :all,
      :group => "SUBSTR(LOWER(#{field.to_s}), 1, 1)"
    @counts = @counts.inject(HashWithIndifferentAccess.new()) do |m,grp|
      grp[0] = grp[0].blank? ? 'Blank' : grp[0]
      m[grp[0]] = m[grp[0].upcase] = grp[1]
      m
    end
    @counts['All'] = total if @options[:all]

    # Reset to default group if group has not records
    self.group = nil unless @counts.has_key? group

    # Find the first group that has records
    all_groups = ('A'..'Z').to_a + ['Blank']
    all_groups << 'All' if @options[:all]
    self.group = all_groups.detect(proc {'A'}) do |ltr|
      @counts.has_key? ltr
    end if group.blank?

    unless (min_records && total >= min_records) || group == 'All'
      # Determine conditions. '' or NULL shows up under "Blank"
      operator = if group == 'Blank'
        # FIXME: Field should be sanatized. Possible SQL Inject attack
        "= '' OR #{field.to_s} IS NULL"
      else
        'LIKE ?'
      end
      # FIXME: Field should be sanatized. Possible SQL Inject attack
      conditions = [
        "#{model.table_name}.#{field.to_s} #{operator}",
        "#{group}%"
      ]
    end

    # Find results for this page
    model.with_scope({:find => {:conditions => conditions}}) {model.find :all}
  end

  # Given a group will return the number of results in that group.
  # Only valid AFTER find has been executed
  def count(grp)
    @counts[grp] || 0
  end

  # Will return the total records found in all groups. Only valid
  # AFTER find has been executed
  def total
    # Don't include 'All' when adding up total or we will get double
    @total ||= (('A'..'Z').to_a + ['Blank']).inject(0) do |total, letter|
      total + count(letter)
    end
  end

  # Will return all groups that have results. Only valid AFTER
  # find has been executed
  def populated_groups
    @counts.keys
  end

  # This helper module is automatically mixed into your views to
  # provide an easy way to display the alphabar.
  module Helper

    # Basic alphabar generator. Just give it the paginator and any
    # options needed. The only current option is :letter_field which
    # indicates the name of the param that will be used to submit the
    # new search. By default it will be ltr.
    #
    # This helper will link all letters that have results. It will
    # also mark the "current" letter with a CSS class 'current'.
    # Finally if there are any "Blank" records a "Blank" group
    # will be appended.
    #
    # If only one letter would show or it doesn't meet the min_records
    # requirement this helper will return an empty string.
    def alphabar(paginator, options={})
      return '' if paginator.min_records && paginator.total < paginator.min_records
      return '' if paginator.populated_groups.size <= 2
      slots = ('A'..'Z').to_a
      slots << 'Blank' if paginator.count('Blank') > 0
      slots << 'All' if paginator.count('All') > 0
      slots.collect do |ltr|
        html_options = {}
        html_options[:class] = 'current' if ltr == paginator.group.to_s
        options = params.dup
        options[options[:letter_field] || 'ltr'] = ltr
        link_to_if paginator.count(ltr) > 0, ltr, options, html_options
      end.compact.join ' '
    end
  end

  # ActiveRecord::Base mixin that will allow alphabar searches on any model
  module AlphaFind

    # Works much like find(:all, find_options) except two arguments are
    # added to indicate the field to search and the group to find.
    # If no group is specified then the first group with results will
    # be used.
    #
    # The find_options can be used to reduce the results beyond
    # what Alphabar is doing and the alpha_options are given to the
    # initializer of the Alphabar object.
    #
    # You can also pass this method a block which allows you to
    # configure the #Alphabar paginator object before the find is
    # executed. The argument to the block is the paginator object.
    #
    # Example usage:
    #
    #   @users, @paginator = User.alpha_find :last_name, params[:ltr]
    def alpha_find(field, group=nil, find_options={}, alpha_options={})
      paginator = Alphabar.new alpha_options
      paginator.field = field
      paginator.group = group
      yield paginator if block_given?
      results = with_scope(:find => find_options) { paginator.find self }
      [results, paginator]
    end
  end
end
