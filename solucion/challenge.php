<h1>Ejercicio 1:</h1>
<p>
    Importa el archivo <code>STORE.SQL</code> en una base de datos MySQL.  
    Luego, imprime todos los registros de la tabla <code>items</code>.  
    Puedes usar la clase <code>Database</code> con las siguientes credenciales:
</p>
<ul>
    <li>Usuario: <code>root</code></li>
    <li>Contraseña: (vacía)</li>
    <li>Base de datos: <code>training</code></li>
    <li>Host: <code>127.0.0.1</code></li>
</ul>

<?php
    // Incluye la clase Database desde el archivo database.php en el mismo directorio
    require_once __DIR__ . '/database.php';

    // Crea una instancia de Database con las credenciales proporcionadas (host, db, user, password vacía)
    $db = new Database('127.0.0.1', 'training', 'root', '');
    // Ejecuta un SELECT * en la tabla items usando el método fetchAll que devuelve un array asociativo
    $items = $db->fetchAll('SELECT * FROM items');
?>

<!-- Tabla HTML que recorre el array $items y muestra cada registro -->
<table border="1" cellpadding="5">
    <tr><th>ID</th><th>Nombre</th><th>Categoría</th></tr>
    <?php foreach ($items as $item): ?>
        <tr>
            <td><?= $item['id'] ?></td>
            <td><?= $item['name'] ?></td>
            <td><?= $item['category'] ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<h1>Ejercicio 2:</h1>
<p>
    Lee y decodifica el archivo <code>promotions.json</code>.  
    Imprime en pantalla el contenido como un arreglo asociativo de PHP.
</p>

<?php
    // Lee todo el contenido del archivo JSON como string
    $promotionsJson = file_get_contents(__DIR__ . '/promotions.json');
    // Convierte el string JSON en un array asociativo de PHP (true = array asociativo, no objeto)
    $promotions = json_decode($promotionsJson, true);
    // print_r muestra la estructura del array; <pre> preserva el formato de saltos de línea en HTML
    echo '<pre>' . print_r($promotions, true) . '</pre>';
?>

<h1>Ejercicio 3:</h1>
<p>
    Lista todas las facturas registradas en la tabla <code>Invoices</code>.  
    Para cada factura, valida si aplica algún descuento con los datos de <code>promotions.json</code> y muestra:
</p>
<ul>
    <li>ID de la factura</li>
    <li>Subtotal</li>
    <li>Descuento aplicado</li>
</ul>

<?php
    // Obtiene todas las facturas con JOIN a items para tener el nombre y categoría del producto
    $invoices = $db->fetchAll('
        SELECT i.id, i.quantity, i.unit_price, it.name, it.category
        FROM invoices i
        JOIN items it ON i.item_id = it.id
        ORDER BY i.id
    ');
?>

<!-- Tabla HTML que recorre $invoices, calcula subtotal y aplica descuento según promociones -->
<table border="1" cellpadding="5">
    <tr><th>ID Factura</th><th>Producto</th><th>Subtotal</th><th>Descuento</th></tr>
    <?php foreach ($invoices as $inv):
        // Calcula el subtotal multiplicando cantidad por precio unitario
        $subtotal = $inv['quantity'] * $inv['unit_price'];
        // Inicializa el descuento en 0 (sin descuento por defecto)
        $discount = 0;

        // Recorre el array de promociones cargado en el ejercicio 2
        foreach ($promotions as $promo) {
            // Si la categoría de la factura coincide con la promoción Y el subtotal supera el umbral...
            if ($promo['category'] === $inv['category'] && $subtotal >= $promo['threshold']) {
                // Calcula el descuento como subtotal * porcentaje de descuento
                $discount = $subtotal * $promo['discount'];
                // Sale del bucle al encontrar la primera promoción que aplica
                break;
            }
        }
    ?>
        <tr>
            <td><?= $inv['id'] ?></td>
            <td><?= $inv['name'] ?></td>
            <!-- number_format da formato con 2 decimales y separador de miles -->
            <td>$<?= number_format($subtotal, 2) ?></td>
            <!-- Si hay descuento, muestra el monto y el porcentaje; si no, muestra "Sin descuento" -->
            <td><?= $discount > 0 ? '$' . number_format($discount, 2) . ' (' . ($discount / $subtotal * 100) . '%)' : 'Sin descuento' ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<h1>Ejercicio 4: (BONUS)</h1>
<p>
    Convierte el subtotal de cada factura a pesos colombianos (COP) utilizando la tasa de conversión proporcionada por el siguiente API:  
    <a href="https://open.er-api.com/v6/latest/USD" target="_blank">https://open.er-api.com/v6/latest/USD</a>.  
    Para cada factura muestra:
</p>
<ul>
    <li>ID de la factura</li>
    <li>Subtotal en USD</li>
    <li>Subtotal en COP</li>
</ul>

<?php
    // Llama a la API pública de tipos de cambio y obtiene la respuesta JSON
    $response = file_get_contents('https://open.er-api.com/v6/latest/USD');
    // Decodifica el JSON en un array asociativo de PHP
    $rates = json_decode($response, true);
    // Extrae la tasa de cambio para COP (Peso Colombiano) del array de rates; ?? 0 por si no existe
    $copRate = $rates['rates']['COP'] ?? 0;
?>

<!-- Tabla que convierte cada subtotal a COP usando la tasa obtenida de la API -->
<table border="1" cellpadding="5">
    <tr><th>ID Factura</th><th>Subtotal USD</th><th>Tasa COP</th><th>Subtotal COP</th></tr>
    <?php foreach ($invoices as $inv):
        // Recalcula el subtotal (mismo cálculo que en el ejercicio 3)
        $subtotal = $inv['quantity'] * $inv['unit_price'];
        // Convierte de USD a COP multiplicando por la tasa de cambio
        $subtotalCop = $subtotal * $copRate;
    ?>
        <tr>
            <td><?= $inv['id'] ?></td>
            <td>$<?= number_format($subtotal, 2) ?></td>
            <td>$<?= number_format($copRate, 2) ?></td>
            <td>$<?= number_format($subtotalCop, 2) ?></td>
        </tr>
    <?php endforeach; ?>
</table>
