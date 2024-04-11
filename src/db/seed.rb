require 'sqlite3'

def db
    if @db == nil
        @db = SQLite3::Database.new('./db/db.sqlite')
        @db.results_as_hash = true
    end
    return @db
end

def drop_tables
    db.execute('DROP TABLE IF EXISTS customers')
    db.execute('DROP TABLE IF EXISTS products')
    db.execute('DROP TABLE IF EXISTS line_items')
    db.execute('DROP TABLE IF EXISTS orders')
    db.execute('DROP TABLE IF EXISTS parts')
    db.execute('DROP TABLE IF EXISTS tags')
end

def create_tables
    db.execute('CREATE TABLE "customers" (
        "id"	INTEGER,
        "first_name"	TEXT NOT NULL,
        "last_name"	TEXT,
        "phone"	TEXT NOT NULL UNIQUE,
        "email"	TEXT NOT NULL UNIQUE,
        "adress"	TEXT NOT NULL,
        "payment_method"	TEXT NOT NULL,
        "password"	TEXT NOT NULL,
        "admin"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')
   
    db.execute('CREATE TABLE "products" (
        "id"	INTEGER,
        "name"	TEXT NOT NULL UNIQUE,
        "price"	INTEGER NOT NULL,
        "description"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')

    db.execute('CREATE TABLE "line_items" (
        "order_id"	INTEGER,
        "item_id"	INTEGER
    )')

    db.execute('CREATE TABLE "orders" (
        "id"	INTEGER,
        "time"	TEXT NOT NULL,
        "customer_id"	INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')

    
    db.execute('CREATE TABLE "parts" (
        "item_id"	INTEGER,
        "tag_id"	INTEGER
    )')

    db.execute('CREATE TABLE "tags" (
        "id"	INTEGER,
        "name"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')

end

def seed_tables

    customers = [
        {first_name: 'Testy', last_name: 'McTestface', adress: 'teststreet test', payment_method: 'tesh', phone: '0112345678', email: 'testy.mctestface@testmail.test', password: 'admin', admin: '1'},
        {first_name: 'Sven', last_name: 'Svensson', adress: 'Svenssongatan 2', payment_method: 'Swish', phone: '0712345678', email: 'sven.svensson@hotmail.com', password: 'admin123', admin: '0'},
        {first_name: 'Anders', last_name: 'Andersson', adress: 'Svenssongatan 3', payment_method: 'debit card', phone: '0723456789', email: 'anders.andersson@gmail.com', password: 'Admin123!', admin: '0'},
        {first_name: 'Lars', last_name: 'Larsson', adress: 'Svenssongatan 1', payment_method: 'credit card', phone: '0734567890', email: 'lars.larsson@icloud.com', password: 'Crz0>n^g"yZx3R7IlWFWyO!SQc}<%MI>3rf4DU}}P[cp<xI', admin: '0'}
    ]

    products = [
        {name: 'Voron 2.4', price: '999', description: 'a sweet, juicy, yellow or green fruit with a round base and slightly pointed top'},
        {name: 'Voron Trident', price: '899', description: 'a round, edible fruit having a red, green, or yellow skin'},
        {name: 'Voron 0.2', price: '399', description: 'a long, curved fruit with a usually yellow skin and soft, sweet flesh inside'},
        {name: 'Prusa mk4', price: '1200', description: 'a round, orange-colored fruit that is valued mainly for its sweet juice'}
    ]

    tags = [
        {name: 'Direct drive'},
        {name: 'Bowden drive'},
        {name: 'All metal hotend'},
        {name: 'PTFE-lined hotend'}
    ]
    
    customers.each do |customer|
        db.execute('INSERT INTO customers (first_name, last_name, phone, email, adress, payment_method, password) VALUES (?,?,?,?,?,?,?)', customer[:first_name], customer[:last_name], customer[:phone], customer[:email], customer[:adress], customer[:payment_method], customer[:password], )
    end

    products.each do |product|
        db.execute('INSERT INTO products (name, price, description) VALUES (?,?,?)', product[:name], product[:price], product[:description])
    end

    tags.each do |tag|
        db.execute('INSERT INTO tags (name) VALUES (?)', tag[:name])
    end    

end




drop_tables
create_tables
seed_tables