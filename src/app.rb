class App < Sinatra::Base

    enable :sessions

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

    before do
        if session[:user_id].nil?
            @user = nil
        else
            @user = db.execute('SELECT * FROM user WHERE ID = ?', session[:user_id])
        end
    end

    get '/' do
        redirect "/products"
    end

    get '/products' do
        @products = db.execute('SELECT * FROM products')
        erb :'products/index'
    end

    get '/products/new' do 
        redirect if @user.nil?
        erb :'products/new'
    end

    post '/products/' do 
        redirect '/products' if @user['admin'] == 1
        name = params['name']
        price = params['price']
        description = params['description'] 
        query = 'INSERT INTO products (name, price, description) VALUES (?, ?, ?) RETURNING *'
        result = db.execute(query, name, price, description).first 
        redirect "/products/#{result['id']}" 
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

    get 'users/register' do
        erb :'register'
    end
    post 'users/register' do
        cleartext_password = params['password'] 
        hashed_password = BCrypt::Password.create(cleartext_password) 
    end

    get 'users/login' do  
        erb :'login'
    end

    post 'users/login' do
        username = params['email']
        cleartext_password = params['password']
        user = db.execute('SELECT * FROM users WHERE email = ?', email).first
        password_from_db = BCrypt::Password.new(user['password'])
        if password_from_db == clertext_password 
            session[:user_id] = user['id'] 
           
          else
            
          end
    end
    
end