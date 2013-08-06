module MintyScopes
  module Associations
  
    def self.extended(within)
      within.class_eval do
        # Only show items that have at least one of the associated items
        # Meant for has_many associations
        # Post.with(:comments)
        scope :with, lambda { |assoc|
          raise "The 'with' scope expects a non-nil argument." if assoc.nil?
          { :joins => assoc.to_sym, :group => "#{quoted_table_name}.id" }
        }
        
        scope :without, lambda {|assoc|
          raise "The 'without' scope expects a non-nil argument." if assoc.nil?
          { :joins => "LEFT JOIN #{assoc.to_s} "+
              "ON #{quoted_table_name}.id = #{assoc.to_s}.#{quoted_table_name.singularize}_id",
            :conditions => {"#{assoc}.id" => nil} }
        }
        scope :including, lambda {|*assocs|
          { :include => assocs.flatten }
        }
        
      end
    end
  
  end
end