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
        "first name"	TEXT NOT NULL,
        "last name"	TEXT,
        "phone"	TEXT NOT NULL UNIQUE,
        "email"	TEXT NOT NULL UNIQUE,
        "adress"	TEXT NOT NULL,
        "payment_method"	TEXT NOT NULL,
        "password"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')
   
    db.execute('CREATE TABLE "products" (
        "id"	INTEGER,
        "name"	TEXT NOT NULL UNIQUE,
        "price"	INTEGER NOT NULL,
        "desc"	TEXT NOT NULL,
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

    db.execute('
    ')

    
)

end

def seed_tables

    fruits = [
        {name: 'Pear', description: 'a sweet, juicy, yellow or green fruit with a round base and slightly pointed top'},
        {name: 'Apple', description: 'a round, edible fruit having a red, green, or yellow skin'},
        {name: 'Banana', description: 'a long, curved fruit with a usually yellow skin and soft, sweet flesh inside'},
        {name: 'Orange', description: 'a round, orange-colored fruit that is valued mainly for its sweet juice'}
    ]

    fruits.each do |fruit|
        db.execute('INSERT INTO products (name, description) VALUES (?,?)', fruit[:name], fruit[:description])
    end

end




drop_tables
create_tables
seed_tables