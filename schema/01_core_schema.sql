drop table if exists users cascade;
create table if not exists users (
	id serial primary key,
	first_name text not null,
	last_name text not null,
	email text not null,
	phone_num text not null,
	created_at timestamp not null,
	birth_year text not null,
	status text not null,
	valid_until timestamp not null
);


--what's the thing about uuids
drop table if exists products cascade;
create table if not exists products (
    id serial primary key,
    price decimal(10, 2) not null,
    name varchar(50) not null,
    description text,
    stock_quantity integer not null default 0,
    category varchar(50) not null
);


drop table if exists orders cascade;
create table if not exists orders (
    id serial primary key,
    user_id integer not null references users(id) on delete cascade,
    -- pending, paid, shipped, delivered, cancelled
    status varchar(10) not null default 'pending',
    created_at timestamp not null,
    updated_at timestamp not null
);


drop table if exists order_items cascade;
create table if not exists order_items (
    id serial primary key,
    order_id integer not null references orders(id) on delete cascade,
    product_id integer not null references products(id) on delete cascade,
    price_at_purchase decimal(10, 2) not null,
    quantity integer not null check (quantity > 0)
);


drop table if exists reviews;
create table if not exists reviews (
    user_id integer not null references users(id) on delete cascade,
    product_id integer not null references products(id) on delete cascade,
    created_at timestamp not null,
    content varchar(100) not null,
    title varchar(50) not null,
    rating integer not null check(rating >= 1 and rating <= 5),
    primary key(user_id, product_id)
);


-- a bit redundant, created to experiment with jsonb
-- is index created for product_id?
drop table if exists product_attributes;
create table if not exists product_attributes (
    product_id integer primary key references products(id) on delete cascade,
    attributes jsonb not null,
    created_at timestamp not null,
    updated_at timestamp not null
);


create index idx_orders_user_id on orders(user_id);
create index idx_order_items_order_id on order_items(order_id);
create index idx_order_items_product_id on order_items(product_id);
--user_id is already indexed as a first key in composite 
create index idx_reviews_product_id on reviews(product_id);

