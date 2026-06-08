<h1>Ejercicio 1:</h1>
<p>
    Carga el archivo <code>DATA.SQL</code> en una base de datos MySQL. A continuación, imprime el contenido de la tabla <code>products</code>.  
    Puedes usar la clase <code>Database</code> con las siguientes credenciales:
</p>
<ul>
    <li>Usuario: <code>root</code></li>
    <li>Contraseña: (vacía)</li>
    <li>Base de datos: <code>challenge</code></li>
    <li>Host: <code>localhost</code></li>
</ul>

<?php
    // Incluye la clase Database desde database.php en el mismo directorio
    require_once __DIR__ . '/database.php';

    // Crea instancia de Database: host localhost, base de datos challenge, usuario root, sin contraseña
    $db = new Database('127.0.0.1', 'challenge', 'root', '');

    // Ejecuta un SELECT en la tabla products usando fetchAll que retorna un array asociativo
    $products = $db->fetchAll('SELECT * FROM products');
?>

<!-- Tabla HTML que recorre el array $products y muestra cada producto -->
<table border="1" cellpadding="5">
    <tr><th>ID</th><th>Nombre</th><th>Categoría</th></tr>
    <?php foreach ($products as $product): ?>
        <tr>
            <td><?= $product['id'] ?></td>
            <td><?= $product['name'] ?></td>
            <td><?= $product['category'] ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<h1>Ejercicio 2:</h1>
<p>
    Lee y decodifica el archivo <code>discount.json</code>, luego imprime el contenido del arreglo resultante.
</p>

<?php
    // file_get_contents lee todo el archivo discount.json como un string
    $discountJson = file_get_contents(__DIR__ . '/discount.json');

    // json_decode convierte el string JSON en un array de PHP
    // El segundo parámetro 'true' hace que sea un array asociativo en lugar de objetos stdClass
    $discounts = json_decode($discountJson, true);

    // print_r muestra la estructura completa del array; <pre> preserva saltos de línea en HTML
    echo '<pre>' . print_r($discounts, true) . '</pre>';
?>

<h1>Ejercicio 3:</h1>
<p>
    Lista todas las órdenes registradas en la tabla <code>Orders</code>.  
    Para cada orden, calcula si aplica un descuento válido usando los datos de <code>discount.json</code> y muestra:
</p>
<ul>
    <li>ID de la orden</li>
    <li>Total antes del descuento</li>
    <li>Descuento aplicado</li>
</ul>

<?php
    // Obtiene todas las órdenes con JOIN a products para tener nombre y categoría del producto
    $orders = $db->fetchAll('
        SELECT o.id, o.quantity, o.unit_price, p.name, p.category
        FROM orders o
        JOIN products p ON o.product_id = p.id
        ORDER BY o.id
    ');
?>

<!-- Tabla HTML que recorre $orders, calcula total y aplica descuento según discount.json -->
<table border="1" cellpadding="5">
    <tr><th>ID Orden</th><th>Producto</th><th>Total antes</th><th>Descuento</th></tr>
    <?php foreach ($orders as $order):
        // Calcula el total multiplicando cantidad por precio unitario
        $total = $order['quantity'] * $order['unit_price'];

        // Inicializa el descuento en 0 (por defecto no hay descuento)
        $discount = 0;

        // Recorre el array de descuentos cargado en el ejercicio 2
        foreach ($discounts as $disc) {
            // Si la categoría del producto coincide Y el total supera o iguala el umbral...
            if ($disc['category'] === $order['category'] && $total >= $disc['threshold']) {
                // Calcula el descuento: total * porcentaje
                $discount = $total * $disc['discount'];
                // Sale del bucle al encontrar la primera promoción aplicable
                break;
            }
        }
    ?>
        <tr>
            <td><?= $order['id'] ?></td>
            <td><?= $order['name'] ?></td>
            <!-- number_format da formato al número con 2 decimales y separador de miles -->
            <td>$<?= number_format($total, 2) ?></td>
            <!-- Si hay descuento, muestra el monto y %; si no, "Sin descuento" -->
            <td><?= $discount > 0 ? '$' . number_format($discount, 2) . ' (' . ($discount / $total * 100) . '%)' : 'Sin descuento' ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<h1>Ejercicio 4: (BONUS)</h1>
<p>
    Convierte el total de cada orden a pesos colombianos (COP) utilizando la tasa de conversión proporcionada por el siguiente API de tipo de cambio:  
    <a href="https://open.er-api.com/v6/latest/USD" target="_blank">https://open.er-api.com/v6/latest/USD</a>.  
    Para cada orden, muestra:
</p>
<ul>
    <li>ID de la orden</li>
    <li>Total en USD</li>
    <li>Total en COP</li>
</ul>

<?php
    // file_get_contents con URL consume la API REST de tipos de cambio
    // open.er-api.com devuelve un JSON con tasas de cambio basadas en USD
    $response = file_get_contents('https://open.er-api.com/v6/latest/USD');

    // Decodifica el JSON de la API en un array asociativo
    $rates = json_decode($response, true);

    // Extrae la tasa de COP del array rates; ?? 0 es el operador de fusión null que asigna 0 si no existe
    $copRate = $rates['rates']['COP'] ?? 0;
?>

<!-- Tabla que convierte cada total a COP usando la tasa obtenida -->
<table border="1" cellpadding="5">
    <tr><th>ID Orden</th><th>Total USD</th><th>Tasa COP</th><th>Total COP</th></tr>
    <?php foreach ($orders as $order):
        // Recalcula el total (mismo cálculo que en el ejercicio 3)
        $total = $order['quantity'] * $order['unit_price'];

        // Convierte de USD a COP: multiplica el total por la tasa de cambio
        $totalCop = $total * $copRate;
    ?>
        <tr>
            <td><?= $order['id'] ?></td>
            <td>$<?= number_format($total, 2) ?></td>
            <td>$<?= number_format($copRate, 2) ?></td>
            <td>$<?= number_format($totalCop, 2) ?></td>
        </tr>
    <?php endforeach; ?>
</table>
