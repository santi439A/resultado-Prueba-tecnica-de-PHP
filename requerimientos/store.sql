-- Tabla de ítems
CREATE TABLE items (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  category VARCHAR(50)
);

INSERT INTO items (id, name, category) VALUES
(1, 'Zapatos',      'Calzado'),
(2, 'Televisor',    'Tecnología'),
(3, 'Silla',        'Hogar'),
(4, 'Celular',      'Tecnología');

-- Tabla de facturas
CREATE TABLE invoices (
  id INT PRIMARY KEY,
  item_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  invoice_date DATE,
  FOREIGN KEY (item_id) REFERENCES items(id)
);

INSERT INTO invoices (id, item_id, quantity, unit_price, invoice_date) VALUES
(1, 1, 2,   40.00, '2025-06-01'),
(2, 2, 1,  800.00, '2025-06-03'),
(3, 3, 4,   25.00, '2025-06-05'),
(4, 4, 2,  600.00, '2025-06-07'),
(5, 1, 3,   40.00, '2025-06-10'),
(6, 3, 2,   25.00, '2025-06-15'),
(7, 2, 1,  800.00, '2025-06-20');

