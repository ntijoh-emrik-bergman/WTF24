class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
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
        name = params['content'] 
        query = 'INSERT INTO products (name) VALUES (?) RETURNING *'
        result = db.execute(query, name).first 
        redirect "/product/#{result['id']}" 
    end

    get '/products/:id/edit' do |id| 
        @product = db.execute('SELECT * FROM products WHERE id = ?', id.to_i).first
        erb :'products/edit'
    end

    post '/products/:id/update' do |id| 
        name = params['content']
        db.execute('UPDATE products SET name = ? WHERE id = ?', name, id)
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