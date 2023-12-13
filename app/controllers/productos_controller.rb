class ProductosController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async.load
    @productos=Producto.with_attached_photo.order(created_at: :desc).load_async.load
    if params[:category_id]
      @productos = @productos.where(category_id: params[:category_id])
    end
  end
  def show
    @producto=Producto.find(params[:id])

  end
  def new
    @producto=Producto.new
  end
  def create
    @producto=Producto.new(producto_params)
    # pp @producto
    if @producto.save
      redirect_to productos_path, notice: t('.created')  
    else
      render :new, status: :unprocessable_entity
      # explicacion: si no se guarda el producto, se renderiza la vista new
      # y se le pasa el status 422
    end 
  end
  def edit
    @producto = Producto.find(params[:id])
    #find se encarga de buscar el producto por id para poder editarlo

  end
  def update
    @producto = Producto.find(params[:id])
    if @producto.update(producto_params)
      redirect_to productos_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @producto = Producto.find(params[:id])
    @producto.destroy
    redirect_to productos_path, notice: t('.deleted') ,status: :see_other
  end
  private
  def producto_params
    params.require(:producto).permit(:titulo,:descripcion,:precio,:photo,:category_id)
  end
end

# < sirve para heredar
# Modelo -- Todo relacionado con la Base de Datos
#           consultas,validaciones,relaciones
# Vista -- Devolver al usuario html,pdf,csv,json
# Controlador -- Logica del proyecto
# @productos -- es una variable de instancia
# Tienda en proceso

#TODO: COMANDO MAGICO DE ruby on rails:
#TODO: ->rails generate scaffold Category name:string description:string{255}
#TODO: ->Siempre que se aplique esto de debe aplicar tambien rails db:migrate
#TODO: ->para ver las peticiones: /rails/info/routes
#TODO: ->para limpiar la base de datos rails db:reset
#TODO: ->para habilitar la consola utiliza rails console
#TODO: ->para ActiveRecord::Base.connection.table_exists?(:products) para verificar si existe una tabla
#TODO: ->para rellenar desde terminal usando las fixtures rails db:fixtures:load
