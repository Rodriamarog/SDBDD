-- Crear tabla Autores
CREATE TABLE Autores (
    AutorID INT PRIMARY KEY,
    NombreAutor VARCHAR(100)
);

-- Insertar datos en Autores
INSERT INTO Autores (AutorID, NombreAutor) VALUES
(1, 'Gabriel García Márquez'),
(2, 'J.K. Rowling'),
(3, 'Stephen King'),
(4, 'Isabel Allende'),
(5, 'George Orwell');

-- Mostrar datos de Autores
SELECT * FROM Autores;

-- Crear tabla Libros
CREATE TABLE Libros (
    LibroID INT PRIMARY KEY,
    Titulo VARCHAR(200),
    AutorID INT,
    Editorial VARCHAR(100),
    FechaPublicacion DATE,
    ISBN VARCHAR(13),
    Precio DECIMAL(10,2),
    FOREIGN KEY (AutorID) REFERENCES Autores(AutorID)
);

-- Insertar datos en Libros
INSERT INTO Libros (LibroID, Titulo, AutorID, Editorial, FechaPublicacion, ISBN, Precio) VALUES
(1, 'Cien años de soledad', 1, 'Editorial Sudamericana', '1967-05-30', '9780307474728', 15.99),
(2, 'Harry Potter y la piedra filosofal', 2, 'Bloomsbury', '1997-06-26', '9780747532699', 12.99),
(3, 'It', 3, 'Viking Press', '1986-09-15', '9780670813029', 14.99),
(4, 'La casa de los espíritus', 4, 'Plaza & Janés', '1982-01-01', '9780525433477', 13.99),
(5, '1984', 5, 'Secker & Warburg', '1949-06-08', '9780451524935', 11.99);

-- Mostrar datos de Libros
SELECT * FROM Libros;

-- Crear tabla Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    NombreCliente VARCHAR(100)
);

-- Insertar datos en Clientes
INSERT INTO Clientes (ClienteID, NombreCliente) VALUES
(1, 'María Rodríguez'),
(2, 'Juan Pérez'),
(3, 'Ana López'),
(4, 'Carlos Gómez'),
(5, 'Laura Martínez');

-- Mostrar datos de Clientes
SELECT * FROM Clientes;

-- Crear tabla Ventas
CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY,
    LibroID INT,
    ClienteID INT,
    FechaVenta DATE,
    CantidadVendida INT,
    FOREIGN KEY (LibroID) REFERENCES Libros(LibroID),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Insertar datos en Ventas
INSERT INTO Ventas (VentaID, LibroID, ClienteID, FechaVenta, CantidadVendida) VALUES
(1, 1, 3, '2024-08-01', 1),
(2, 2, 1, '2024-08-02', 2),
(3, 3, 4, '2024-08-03', 1),
(4, 4, 2, '2024-08-04', 1),
(5, 5, 5, '2024-08-05', 3);

-- Mostrar datos de Ventas
SELECT * FROM Ventas;
