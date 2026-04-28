--5600 users
insert into users(first_name, last_name, email, phone_num, created_at, birth_year, status)
with names as (
	select 
		array['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 'William', 'Elizabeth',
          'David', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica', 'Thomas', 'Sarah', 'Charles', 'Karen',
          'Christopher', 'Nancy', 'Daniel', 'Lisa', 'Matthew', 'Betty', 'Anthony', 'Margaret', 'Donald', 'Sandra',
          'Mark', 'Ashley', 'Paul', 'Dorothy', 'Steven', 'Kimberly', 'Andrew', 'Emily', 'Kenneth', 'Donna',
          'Joshua', 'Michelle', 'Kevin', 'Carol', 'Brian', 'Amanda', 'George', 'Melissa', 'Edward', 'Deborah',
          'Stephen', 'Anna', 'Larry', 'Brenda', 'Justin', 'Pamela', 'Scott', 'Nicole', 'Brandon', 'Emma',
          'Benjamin', 'Samantha', 'Samuel', 'Katherine', 'Frank', 'Christine', 'Gregory', 'Debra', 'Raymond', 'Rachel',
          'Alexander', 'Catherine', 'Patrick', 'Carolyn', 'Jack', 'Janet', 'Dennis', 'Ruth', 'Jerry', 'Maria'] as first_names,
		array['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
          'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
          'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson',
          'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores',
          'Green', 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell', 'Carter', 'Roberts',
          'Watson', 'Brooks', 'Chavez', 'Wood', 'James', 'Bennett', 'Gray', 'Mendoza', 'Ruiz', 'Hughes',
          'Price', 'Alvarez', 'Castillo', 'Sanders', 'Patel', 'Myers', 'Long', 'Ross', 'Foster', 'Jimenez'] as last_names
)
select 
	fn as first_name,
	ln as last_name,
	lower(fn || '.' || ln) || '@gmail.com' as email,
	'+3' || LPAD(floor(random() * 10000000000)::text, 11, '0') as phone_num,
	current_timestamp as created_at,
	floor(random() * (2010 - 1984 + 1) + 1984)::int as birth_year,
	'user' as status
from names
cross join unnest(first_names) as fn
cross join unnest(last_names) as ln
order by random();

--Categories
insert into categories(name, description)
with names as (
     select array[
        'Electronics',
        'Clothing',
        'Home & Kitchen',
        'Sports',
        'Books',
        'Toys',
        'Beauty',
        'Automotive',
        'Garden',
        'Health'
    ] as categories
)
select 
     category as name, 
     'category_' || idx as description
from names 
cross join unnest(categories) with ordinality as t(category, idx);


--Products 
insert into products(category_id, price, name, description, stock_quantity)
select 
     c.id as category_id,
     1000 as price,
     'product_' || s || '_' || c.id as name,
     'product_description_' || s as description,
     100 as stock_quantity
from categories c 
cross join lateral (
     select floor(random() * (15 - 5 + 1) + 5)::int as cnt
     where c.id is not null
) r
cross join lateral (
     select generate_series(1, r.cnt) as s
) t;
