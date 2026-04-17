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