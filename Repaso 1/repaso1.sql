-- Creación de la base de datos
DROP DATABASE IF EXISTS aerolinea; 
CREATE DATABASE IF NOT EXISTS aerolinea;
USE aerolinea;

-- Creación de las tablas
CREATE TABLE Ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Aeropuerto (
    id_aeropuerto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    id_ciudad INT,
    descripcion VARCHAR(255),
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE Estado_vuelo (
    id_estado_vuelo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Compania_aerea (
    id_compania_aerea INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Servicio_comida (
    id_servicio_comida INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Aeronave (
    id_aeronave INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Vuelo (
    num_vuelo INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    duracion INT,
    distancia INT,
    id_aeropuerto_salida INT,
    hora_salida DATETIME,
    id_aeropuerto_llegada INT,
    hora_llegada DATETIME,
    id_estado_vuelo INT,
    id_compania_aerea INT,
    id_servicio_comida INT,
    id_aeronave INT,
    FOREIGN KEY (id_aeropuerto_salida) REFERENCES Aeropuerto(id_aeropuerto),
    FOREIGN KEY (id_aeropuerto_llegada) REFERENCES Aeropuerto(id_aeropuerto),
    FOREIGN KEY (id_estado_vuelo) REFERENCES Estado_vuelo(id_estado_vuelo),
    FOREIGN KEY (id_compania_aerea) REFERENCES Compania_aerea(id_compania_aerea),
    FOREIGN KEY (id_servicio_comida) REFERENCES Servicio_comida(id_servicio_comida),
    FOREIGN KEY (id_aeronave) REFERENCES Aeronave(id_aeronave)
);

CREATE TABLE Tipo_documento (
    id_tipo_documento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Pasajero (
    id_tipo_documento INT,
    num_documento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    num_telefono_contacto INT,
    correo_electronico VARCHAR(255),
    FOREIGN KEY (id_tipo_documento) REFERENCES Tipo_documento(id_tipo_documento)
);

CREATE TABLE Estado_asiento (
    id_estado_asiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE Asiento (
    id_asiento INT AUTO_INCREMENT PRIMARY KEY,
    fila INT,
    numero INT,
    id_estado_asiento INT,
    FOREIGN KEY (id_estado_asiento) REFERENCES Estado_asiento(id_estado_asiento)
);

CREATE TABLE Reserva (
    num_reserva INT AUTO_INCREMENT PRIMARY KEY,
    num_vuelo INT,
    num_documento INT,
    id_tipo_documento INT,
    id_asiento INT,
    costo INT,
    FOREIGN KEY (num_vuelo) REFERENCES Vuelo(num_vuelo),
    FOREIGN KEY (num_documento) REFERENCES Pasajero(num_documento),
    FOREIGN KEY (id_asiento) REFERENCES Asiento(id_asiento)
);
   
