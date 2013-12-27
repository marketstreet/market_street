class Country < ActiveRecord::Base
  has_many :states

  validates :name,  :presence => true,       :length => { :maximum => 200 }
  validates :abbreviation,  :presence => true,       :length => { :maximum => 10 }

  scope :active,   -> {where(:active => true)}
  
  USA_ID    = 214
  CANADA_ID = 35

  after_save :expire_cache

  ACTIVE_COUNTRY_IDS = [CANADA_ID, USA_ID]

  # Call this method to display the country_abbreviation - country with and appending name
  #
  # @example abbreviation == USA, country == 'United States'
  #   country.abbreviation_name(': capitalist') => 'USA - United States : capitalist'
  #
  # @param [append name, optional]
  # @return [String] country abbreviation - country name
  def abbreviation_name(append_name = "")
    ([abbreviation, name].join(" - ") + " #{append_name}").strip
  end

  # Finds all the countries for a form select .
  #
  # @param none
  # @return [Array] an array of arrays with [string, country.id]
  def self.form_selector
    Rails.cache.fetch("Country-form_selector") do
      data = Country.where(:active => true).order('abbreviation ASC').map { |c| [c.abbreviation_name, c.id] }
      data.blank? ? [[]] : data
    end
  end

  def self.create_all
    file_to_load = Rails.root + 'db/seed/countries.yml'
    countries_list = YAML::load( File.open( file_to_load ) )

    countries_list.each_pair do |key, hash|
      c = Country.find_or_create_by(hash)
      c.update_attribute(:active, true) if ACTIVE_COUNTRY_IDS.include?(c.id)      
    end
  end

  private
  def expire_cache
    Rails.cache.delete("Country-form_selector")
  end
end
