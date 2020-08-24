class Product < ApplicationRecord
    validates :title, :description, presence: true
    validates :price, numericality: {greater_than_or_equal_to: 0.01}
    validates :title, uniqueness: true


    has_many :line_items
    has_many :orders, through: :line_items
    has_many :photos, dependent: :destroy
    
    before_destroy :ensure_not_referenced_by_any_line_item

    scope :min_price, -> (filter_min_price) {
    
        if(filter_min_price.to_f > 0) 
            where("price > #{filter_min_price}")
        end
        
    }
    
    scope :max_price, -> (filter_max_price) { 
        
        if(filter_max_price.to_f > 0) 
            where("price < #{filter_max_price}")
        end
    
    }

    scope :date_created, -> (filter_date_min, filter_date_max) { 
        
        if(filter_date_min != '' && filter_date_max != '') 
            where("date(created_at) BETWEEN '#{filter_date_min}' AND '#{filter_date_max}'")
        end
    
    }

    scope :title_like, -> (filter_title) { where('title like ?', '%'+filter_title+'%')}
    scope :description_like, -> (filter_description) { where('description like ?', '%'+filter_description+'%')}

    private
     # ensure that there are no line items referencing this product
        def ensure_not_referenced_by_any_line_item
            unless line_items.empty?
            errors.add(:base, 'Line Items present')
            throw :abort
        end
     end


end
