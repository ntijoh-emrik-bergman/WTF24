class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    helpers do
        def h(text)
            Rack::Utils.escape_html(text)
        end
    end

    get '/' do
        erb :index
    end

    get '/products' do
        @products = db.execute('SELECT * FROM products')
        erb :'products/index'
    end

    get '/products/new' do 
        erb :'products/new'
    end

    post '/products/' do 
        name = params['name']
        price = params['price']
        description = params['description'] 
        query = 'INSERT INTO products (name, price, description) VALUES (?, ?, ?) RETURNING *'
        result = db.execute(query, name, price, description).first 
        redirect "/product/#{result['id']}" 
    end

    get '/products/:id/edit' do |id| 
        @product = db.execute('SELECT * FROM products WHERE id = ?', id.to_i).first
        erb :'products/edit'
    end

    post '/products/:id/update' do |id| 
        name = params['name']
        price = params['price']
        description = params['description']
        db.execute('UPDATE products SET name = ?, price = ?, description = ? WHERE id = ?', name, price, description, id)
        redirect "/products/#{id}" 
    end

  
    post '/products/:id/delete' do |id| 
        db.execute('DELETE FROM products WHERE id = ?', id)
		redirect "/products"
    end  

    get '/products/:id' do |id| 
        @product = db.execute('SELECT * FROM products WHERE id = ?', id).first 
        erb :'products/show'
    end
    
end