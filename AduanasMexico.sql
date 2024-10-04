-- Creación de la base de datos
CREATE DATABASE AduanasMexico;
GO

USE AduanasMexico;
GO

-- Tabla de Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    RazonSocial NVARCHAR(100) NOT NULL,
    RFC NVARCHAR(13) NOT NULL,
    Direccion NVARCHAR(200),
    Ciudad NVARCHAR(50),
    Estado NVARCHAR(50),
    CodigoPostal NVARCHAR(5),
    Telefono NVARCHAR(15),
    Email NVARCHAR(100)
);

-- Tabla de Agentes Aduanales
CREATE TABLE AgentesAduanales (
    AgenteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    NumeroPatente NVARCHAR(10) NOT NULL,
    RFC NVARCHAR(13) NOT NULL,
    Telefono NVARCHAR(15),
    Email NVARCHAR(100)
);

-- Tabla de Aduanas
CREATE TABLE Aduanas (
    AduanaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Ciudad NVARCHAR(50),
    Estado NVARCHAR(50),
    CodigoAduana NVARCHAR(10) NOT NULL
);

-- Tabla de Declaraciones Aduaneras
CREATE TABLE DeclaracionesAduaneras (
    DeclaracionID INT PRIMARY KEY IDENTITY(1,1),
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
    AgenteID INT FOREIGN KEY REFERENCES AgentesAduanales(AgenteID),
    AduanaID INT FOREIGN KEY REFERENCES Aduanas(AduanaID),
    NumeroDeclaracion NVARCHAR(20) NOT NULL,
    FechaDeclaracion DATE NOT NULL,
    TipoOperacion NVARCHAR(20) NOT NULL, 
    ValorMercancia DECIMAL(18,2) NOT NULL,
    Estatus NVARCHAR(20) NOT NULL
);

-- Tabla de Mercancías
CREATE TABLE Mercancias (
    MercanciaID INT PRIMARY KEY IDENTITY(1,1),
    DeclaracionID INT FOREIGN KEY REFERENCES DeclaracionesAduaneras(DeclaracionID),
    Descripcion NVARCHAR(200) NOT NULL,
    FraccionArancelaria NVARCHAR(10) NOT NULL,
    Cantidad INT NOT NULL,
    UnidadMedida NVARCHAR(20) NOT NULL,
    ValorUnitario DECIMAL(18,2) NOT NULL,
    PaisOrigen NVARCHAR(50) NOT NULL
);

-- Tabla de Pagos de Impuestos
CREATE TABLE PagosImpuestos (
    PagoID INT PRIMARY KEY IDENTITY(1,1),
    DeclaracionID INT FOREIGN KEY REFERENCES DeclaracionesAduaneras(DeclaracionID),
    FechaPago DATE NOT NULL,
    MontoPagado DECIMAL(18,2) NOT NULL,
    MetodoPago NVARCHAR(50) NOT NULL,
    ReferenciaPago NVARCHAR(50)
);

-- Índices para mejorar el rendimiento
CREATE INDEX IX_Clientes_RFC ON Clientes(RFC);
CREATE INDEX IX_AgentesAduanales_NumeroPatente ON AgentesAduanales(NumeroPatente);
CREATE INDEX IX_DeclaracionesAduaneras_NumeroDeclaracion ON DeclaracionesAduaneras(NumeroDeclaracion);
CREATE INDEX IX_Mercancias_FraccionArancelaria ON Mercancias(FraccionArancelaria);

-- Vista: Resumen de Declaraciones por Cliente
CREATE VIEW vw_ResumenDeclaracionesPorCliente AS
SELECT 
    c.ClienteID,
    c.RazonSocial,
    COUNT(d.DeclaracionID) AS TotalDeclaraciones,
    SUM(d.ValorMercancia) AS ValorTotalMercancia,
    MAX(d.FechaDeclaracion) AS UltimaDeclaracion
FROM 
    Clientes c
LEFT JOIN 
    DeclaracionesAduaneras d ON c.ClienteID = d.ClienteID
GROUP BY 
    c.ClienteID, c.RazonSocial;
GO

-- Vista: Mercancías más Importadas/Exportadas
CREATE VIEW vw_MercanciasMasMovidas AS
SELECT TOP 10
    m.FraccionArancelaria,
    m.Descripcion,
    COUNT(*) AS TotalMovimientos,
    SUM(m.Cantidad) AS CantidadTotal,
    SUM(m.Cantidad * m.ValorUnitario) AS ValorTotal
FROM 
    Mercancias m
JOIN 
    DeclaracionesAduaneras d ON m.DeclaracionID = d.DeclaracionID
GROUP BY 
    m.FraccionArancelaria, m.Descripcion
ORDER BY 
    TotalMovimientos DESC;
GO

-- Procedimiento Almacenado: Insertar Nueva Declaración Aduanera
CREATE PROCEDURE sp_InsertarDeclaracionAduanera
    @ClienteID INT,
    @AgenteID INT,
    @AduanaID INT,
    @NumeroDeclaracion NVARCHAR(20),
    @FechaDeclaracion DATE,
    @TipoOperacion NVARCHAR(20),
    @ValorMercancia DECIMAL(18,2),
    @Estatus NVARCHAR(20)
AS
BEGIN
    INSERT INTO DeclaracionesAduaneras (ClienteID, AgenteID, AduanaID, NumeroDeclaracion, FechaDeclaracion, TipoOperacion, ValorMercancia, Estatus)
    VALUES (@ClienteID, @AgenteID, @AduanaID, @NumeroDeclaracion, @FechaDeclaracion, @TipoOperacion, @ValorMercancia, @Estatus);
    
    SELECT SCOPE_IDENTITY() AS NuevaDeclaracionID;
END;
GO

-- Procedimiento Almacenado: Obtener Detalles de Declaración
CREATE PROCEDURE sp_ObtenerDetallesDeclaracion
    @DeclaracionID INT
AS
BEGIN
    SELECT 
        d.DeclaracionID, d.NumeroDeclaracion, d.FechaDeclaracion, d.TipoOperacion, d.ValorMercancia, d.Estatus,
        c.RazonSocial AS Cliente, a.Nombre AS AgenteAduanal, ad.Nombre AS Aduana,
        m.Descripcion AS Mercancia, m.FraccionArancelaria, m.Cantidad, m.ValorUnitario
    FROM 
        DeclaracionesAduaneras d
    JOIN 
        Clientes c ON d.ClienteID = c.ClienteID
    JOIN 
        AgentesAduanales a ON d.AgenteID = a.AgenteID
    JOIN 
        Aduanas ad ON d.AduanaID = ad.AduanaID
    LEFT JOIN 
        Mercancias m ON d.DeclaracionID = m.DeclaracionID
    WHERE 
        d.DeclaracionID = @DeclaracionID;
END;
GO

-- Procedimiento Almacenado: Actualizar Estatus de Declaración
CREATE PROCEDURE sp_ActualizarEstatusDeclaracion
    @DeclaracionID INT,
    @NuevoEstatus NVARCHAR(20)
AS
BEGIN
    UPDATE DeclaracionesAduaneras
    SET Estatus = @NuevoEstatus
    WHERE DeclaracionID = @DeclaracionID;

    SELECT @@ROWCOUNT AS FilasActualizadas;
END;
GO

-- Vista: Resumen de Pagos por Cliente
CREATE VIEW vw_ResumenPagosPorCliente AS
SELECT 
    c.ClienteID,
    c.RazonSocial,
    COUNT(p.PagoID) AS TotalPagos,
    SUM(p.MontoPagado) AS MontoTotalPagado,
    MAX(p.FechaPago) AS UltimoPago
FROM 
    Clientes c
LEFT JOIN 
    DeclaracionesAduaneras d ON c.ClienteID = d.ClienteID
LEFT JOIN 
    PagosImpuestos p ON d.DeclaracionID = p.DeclaracionID
GROUP BY 
    c.ClienteID, c.RazonSocial;
GO

-- Procedimiento Almacenado: Insertar Nuevo Pago de Impuestos
CREATE PROCEDURE sp_InsertarPagoImpuestos
    @DeclaracionID INT,
    @FechaPago DATE,
    @MontoPagado DECIMAL(18,2),
    @MetodoPago NVARCHAR(50),
    @ReferenciaPago NVARCHAR(50)
AS
BEGIN
    INSERT INTO PagosImpuestos (DeclaracionID, FechaPago, MontoPagado, MetodoPago, ReferenciaPago)
    VALUES (@DeclaracionID, @FechaPago, @MontoPagado, @MetodoPago, @ReferenciaPago);
    
    SELECT SCOPE_IDENTITY() AS NuevoPagoID;
END;
GO