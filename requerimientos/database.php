<?php
class Database
{
    /** @var \PDO */
    private $pdo;

    /**
     * Construye la conexión PDO.
     *
     * @param string $host     Host de la base de datos (p.ej. '127.0.0.1')
     * @param string $dbname   Nombre de la base de datos
     * @param string $user     Usuario de la base de datos
     * @param string $password Contraseña del usuario
     * @param string $charset  Juego de caracteres (por defecto utf8mb4)
     * @throws \PDOException  Si la conexión falla
     */
    public function __construct(
        string $host,
        string $dbname,
        string $user,
        string $password,
        string $charset = 'utf8mb4'
    ) {
        $dsn = "mysql:host={$host};dbname={$dbname};charset={$charset}";
        $options = [
            \PDO::ATTR_ERRMODE            => \PDO::ERRMODE_EXCEPTION,
            \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
            \PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        $this->pdo = new \PDO($dsn, $user, $password, $options);
    }

    /**
     * Ejecuta una consulta SQL (INSERT, UPDATE, DELETE).
     *
     * @param string $sql    Sentencia SQL con placeholders (?)
     * @param array  $params Valores a ligar en la consulta
     * @return int           Número de filas afectadas
     */
    public function execute(string $sql, array $params = []): int
    {
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount();
    }

    /**
     * Obtiene todos los registros de una consulta SELECT.
     *
     * @param string $sql    Sentencia SQL con placeholders (?)
     * @param array  $params Valores a ligar en la consulta
     * @return array         Array de filas (cada fila es un array asociativo)
     */
    public function fetchAll(string $sql, array $params = []): array
    {
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    /**
     * Obtiene un solo registro de una consulta SELECT.
     *
     * @param string $sql    Sentencia SQL con placeholders (?)
     * @param array  $params Valores a ligar en la consulta
     * @return array|null    Fila única o null si no hay resultados
     */
    public function fetchOne(string $sql, array $params = []): ?array
    {
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        $row = $stmt->fetch();
        return $row === false ? null : $row;
    }
}
