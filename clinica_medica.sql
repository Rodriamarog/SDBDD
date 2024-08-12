-- Crear la tabla Paciente
CREATE TABLE Paciente (
    paciente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_nacimiento DATE,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Insertar datos en la tabla Paciente
INSERT INTO Paciente (paciente_id, nombre, fecha_nacimiento, direccion, telefono, email) VALUES
(1, 'Ana García', '1985-03-15', 'Calle Principal 123, Ciudad', '555-1234', 'ana@email.com'),
(2, 'Carlos López', '1990-07-22', 'Avenida Central 456, Pueblo', '555-5678', 'carlos@email.com'),
(3, 'María Rodríguez', '1978-11-30', 'Plaza Mayor 789, Villa', '555-9012', 'maria@email.com'),
(4, 'Juan Martínez', '1995-01-05', 'Calle Secundaria 321, Urbe', '555-3456', 'juan@email.com'),
(5, 'Laura Sánchez', '1988-09-18', 'Paseo del Parque 654, Metrópoli', '555-7890', 'laura@email.com');

-- Mostrar los datos insertados
SELECT * FROM Paciente;

-- Crear la tabla Medico
CREATE TABLE Medico (
    medico_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

-- Insertar datos en la tabla Medico
INSERT INTO Medico (medico_id, nombre, especialidad) VALUES
(1, 'Dr. Javier Ruiz', 'Cardiología'),
(2, 'Dra. Elena Torres', 'Pediatría'),
(3, 'Dr. Ricardo Vargas', 'Dermatología'),
(4, 'Dra. Sofía Mendoza', 'Neurología'),
(5, 'Dr. Alberto Castro', 'Traumatología');

-- Mostrar los datos de Medico
SELECT * FROM Medico;

-- Crear la tabla Cita
CREATE TABLE Cita (
    cita_id INTEGER PRIMARY KEY,
    paciente_id INTEGER,
    medico_id INTEGER,
    fecha DATE,
    hora TIME,
    diagnostico VARCHAR(200),
    FOREIGN KEY (paciente_id) REFERENCES Paciente(paciente_id),
    FOREIGN KEY (medico_id) REFERENCES Medico(medico_id)
);

-- Insertar datos en la tabla Cita
INSERT INTO Cita (cita_id, paciente_id, medico_id, fecha, hora, diagnostico) VALUES
(1, 1, 1, '2024-08-15', '09:00:00', 'Hipertensión leve'),
(2, 2, 2, '2024-08-15', '10:30:00', 'Infección respiratoria'),
(3, 3, 3, '2024-08-16', '11:00:00', 'Dermatitis alérgica'),
(4, 4, 4, '2024-08-16', '14:00:00', 'Migraña crónica'),
(5, 5, 5, '2024-08-17', '16:30:00', 'Esguince de tobillo');

-- Mostrar los datos de Cita
SELECT * FROM Cita;

-- Crear la tabla Tratamiento
CREATE TABLE Tratamiento (
    tratamiento_id INTEGER PRIMARY KEY,
    cita_id INTEGER,
    descripcion VARCHAR(200),
    costo DECIMAL(10, 2),
    FOREIGN KEY (cita_id) REFERENCES Cita(cita_id)
);

-- Insertar datos en la tabla Tratamiento
INSERT INTO Tratamiento (tratamiento_id, cita_id, descripcion, costo) VALUES
(1, 1, 'Medicación antihipertensiva', 150.00),
(2, 2, 'Antibióticos y reposo', 100.00),
(3, 3, 'Crema corticoide tópica', 80.00),
(4, 4, 'Terapia preventiva de migraña', 200.00),
(5, 5, 'Vendaje y fisioterapia', 180.00);

-- Mostrar los datos de Tratamiento
SELECT * FROM Tratamiento;

-- Crear la tabla Factura
CREATE TABLE Factura (
    factura_id INTEGER PRIMARY KEY,
    cita_id INTEGER,
    fecha DATE,
    monto DECIMAL(10, 2),
    FOREIGN KEY (cita_id) REFERENCES Cita(cita_id)
);

-- Insertar datos en la tabla Factura
INSERT INTO Factura (factura_id, cita_id, fecha, monto) VALUES
(1, 1, '2024-08-15', 200.00),
(2, 2, '2024-08-15', 150.00),
(3, 3, '2024-08-16', 130.00),
(4, 4, '2024-08-16', 250.00),
(5, 5, '2024-08-17', 230.00);

-- Mostrar los datos de Factura
SELECT * FROM Factura;
