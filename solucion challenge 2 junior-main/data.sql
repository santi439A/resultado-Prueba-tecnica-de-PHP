-- Tabla de productos
CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  category VARCHAR(50)
);

INSERT INTO products (id, name, category) VALUES
(1, 'Camiseta',    'Ropa'),
(2, 'Jeans',       'Ropa'),
(3, 'Taza',        'Hogar'),
(4, 'Portátil',    'Electrónica');

-- Tabla de órdenes
CREATE TABLE orders (
  id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  order_date DATE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO orders (id, product_id, quantity, unit_price, order_date) VALUES
(1, 1, 3,  20.00, '2025-05-01'),
(2, 2, 1,  50.00, '2025-05-02'),
(3, 3, 10,  5.00, '2025-05-03'),
(4, 4, 2, 500.00, '2025-05-04'),
(5, 1, 2,  20.00, '2025-05-15'),
(6, 3,  2,  5.00, '2025-05-20'),
(7, 4,  1,500.00, '2025-05-22');
