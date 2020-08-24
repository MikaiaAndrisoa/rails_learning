class PhotosController < ApplicationController
    #Index action, photos gets listed in the order at which they were created
    def index
        @photos = Photo.order('created_at')
    end
  
   #New action for creating a new photo
    def new

        @photo = Photo.new
    
    end
  
   #Create action ensures that submitted photo gets created if it meets the requirements
   def create
    
        @photo = Photo.new(photo_params)
        
        if @photo.save
        
            redirect_to root_path
        
        else
            
            flash[:alert] = "Error adding new photo!"
    
        end
    
    end
  
    def destroy

        @picture = Photo.find(params[:id])
        @product_id = @picture.product_id
        @picture.destroy
    
        respond_to do |format|
          format.html { redirect_to controller: 'products', action: 'edit', id: @product_id }
          format.js
        end
    end


   private
  
   #Permitted parameters when creating a photo. This is used for security reasons.
   def photo_params
    params.require(:photo).permit(:image, :product_id)
   end
  
end
