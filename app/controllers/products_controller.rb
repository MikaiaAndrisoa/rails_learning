
class ProductsController < ApplicationController
  
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  # GET /products
  # GET /products.json
  def index
   #@products = Product.all
   products_scope = Product.all

   #filter the title
   products_scope = products_scope.title_like(params[:filter_title]) if params[:filter_title]
   
   #filter the description
   products_scope = products_scope.description_like(params[:filter_description]) if params[:filter_description]
   
   #price filtering
   products_scope = products_scope.min_price(params[:filter_min_price]) if params[:filter_min_price]
   products_scope = products_scope.max_price(params[:filter_max_price]) if params[:filter_max_price]

   #date filtering
   products_scope = products_scope.date_created(params[:filter_date_min], params[:filter_date_max]) if params[:filter_date_min] && params[:filter_date_max]
   #products_scope = products_scope.max_date_created(params[:filter_date_max]) if params[:filter_date_max]

   smart_listing_create(:products, products_scope, partial: "products/product_list", default_sort: {title: "asc"})

  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        if params[:images]
          #abort("boum")
          params[:images].each { |image|
          
            @product.photos.create(image: image, product_id: @product.id)
          }

        end
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        
        if params[:images]
          #abort("boum")
          params[:images].each { |image|
          
            @product.photos.create(image: image, product_id: @product.id)
          }

        end
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
        @products = Product.all
        ActionCable.server.broadcast 'products',
        html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :filter_description, :filter_title, :filter_min_price, :filter_max_price, :filter_date_min, :filter_date_max, images: [])
    end
    
    def who_bought
      @product = Product.find(params[:id])
      @latest_order = @product.orders.order(:updated_at).last
        if stale?(@latest_order)
          respond_to do |format|
          format.atom
        end
      end
     end

end
