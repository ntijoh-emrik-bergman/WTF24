require 'debug'

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
            @user = db.execute('SELECT * FROM users WHERE ID = ?', session[:user_id]).first
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
        if @user.nil? 
            redirect back
        elsif  @user["admin"] == 0
            redirect back
        else
            name = params['name']
            price = params['price']
            description = params['description'] 
            query = 'INSERT INTO products (name, price, description) VALUES (?, ?, ?) RETURNING *'
            result = db.execute(query, name, price, description).first 
            redirect "/products/#{result['id']}" 
        end
    end

    get '/products/:id/edit' do |id| 
        @product = db.execute('SELECT * FROM products WHERE id = ?', id.to_i).first
        erb :'products/edit'
    end

    post '/products/:id/update' do |id| 
        if @user.nil? 
            redirect back
        elsif  @user["admin"] == 0
            redirect back
        else
            name = params['name']
            price = params['price']
            description = params['description']
            db.execute('UPDATE products SET name = ?, price = ?, description = ? WHERE id = ?', name, price, description, id)
            redirect "/products/#{id}" 
        end
    end

    post '/products/:id/delete' do |id| 
        if @user.nil? 
            redirect back
        elsif  @user["admin"] == 0
            redirect back
        else
            db.execute('DELETE FROM products WHERE id = ?', id)
            redirect "/products"
        end
    end  

    get '/products/:id' do |id| 
        @product = db.execute('SELECT * FROM products WHERE id = ?', id).first 
        erb :'products/show'
    end

    get '/users/register' do
        erb :'users/register'
    end

    post '/users/register' do
        cleartext_password = params['password'] 
        password = BCrypt::Password.create(cleartext_password) 
        first_name = params['first_name']
        last_name = params['last_name']
        adress = params['adress']
        payment_method = params['payment_method']
        phone = params['phone']
        email = params['email']
        query = 'INSERT INTO users (first_name, last_name, adress, payment_method, phone, email, password) VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING *'
        result = db.execute(query, first_name, last_name, adress, payment_method, phone, email, password).first 
        redirect "../"
    end

    get '/users/login' do  
        erb :'users/login'
    end

    post '/users/login' do
        username = params['email']
        cleartext_password = params['password']
        user = db.execute('SELECT * FROM users WHERE email = ?', username).first
        p user
        password_from_db = BCrypt::Password.new(user['password'])
        if password_from_db == cleartext_password 
            session[:user_id] = user['id'] 
           redirect "/products"
          else
            redirect back
        end
    end
end