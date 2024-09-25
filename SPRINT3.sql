-- NIVELL 1

-- EXERCICI 1:
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
-- La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
-- Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

CREATE TABLE credit_card (
	id varchar(15) PRIMARY KEY,
    iban varchar(50),
    pan varchar(25),
    pin varchar(4),
    cvv varchar(3),
    expiring_date varchar(10)
);

-- Establir connexió entre les taules 'transaction' y 'credit_card':
-- Per a que no doni error posar això primer:
SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE transactions.transaction
ADD CONSTRAINT id_credit_card_fk
FOREIGN KEY (credit_card_id)
REFERENCES transactions.credit_card(id);

-- EXERCICI 2:
-- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card SET iban = 'R323456312213576817699999' WHERE id = 'CcU-2938';

-- EXERCICI 3:
-- En la taula "transaction" ingressa un nou usuari amb la següent informació:
-- Id = 108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id = CcU-9999
-- company_id = b-9999
-- user_id = 9999
-- lat = 829.999
-- longitude = -117.999
-- amount = 111.11
-- declined = 0

-- Sortía un error amb codi 1452 que l'he solucionat amb:
SET FOREIGN_KEY_CHECKS=0;

INSERT INTO TRANSACTION 
( id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES 
('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

-- EXERCICI 4:
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card DROP COLUMN pan;

-- NIVELL 2

-- EXERCICI 1:
-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

DELETE FROM 
transaction 
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- EXERCICI 2:
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
-- Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW 
	VistaMarketing AS
SELECT 
	company.company_name AS 'Nom de la companyia', 
    company.phone AS 'Telèfon', 
    company.country AS 'Pais', 
    AVG(transaction.amount) AS 'Mitja de compres'
FROM 
	company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY 
	company.company_name, company.phone, company.country
ORDER BY 
	AVG(transaction.amount) DESC;

-- comprobació:
SELECT *
FROM 
	vistamarketing;

-- EXERCICI 3:
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

CREATE VIEW 
	VistaMarketing_Germany AS
SELECT 
	company.company_name AS 'Nom de la companyia', 
    company.phone AS 'Telèfon', 
    company.country AS 'Pais', 
    AVG(transaction.amount) AS 'Mitja de compres'
FROM 
	company
JOIN transaction
ON company.id = transaction.company_id
WHERE 
	company.country = 'Germany'
GROUP BY 
	company.company_name, company.phone, company.country
ORDER BY 
	AVG(transaction.amount) DESC;

-- comprobació:
SELECT *
FROM 
	vistamarketing_germany;
    
-- NIVELL 3

-- EXERCICI 1:
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip 
-- va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
-- Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

-- Treure 'website' de la taula 'company'
ALTER TABLE company DROP COLUMN website;

-- Canviar el nom de la taula ‘user’ a ‘data_user’
RENAME table user to data_user;

-- De la taula ‘user’ canviar la columna ‘email’ per ‘personal_email’
ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

-- De la taula ‘credit_card’ canviar el tipus de dada de ‘cvv’ de ‘varchar’ a ‘int’
ALTER TABLE credit_card
MODIFY COLUMN cvv INT;

-- Crear una nova columna anomenada ‘fecha_actual’ a la taula ‘credit_card’
ALTER TABLE credit_card
ADD fecha_actual DATE;

-- EXERCICI 2:
-- L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
-- ID de la transacció
-- Nom de l'usuari/ària
-- Cognom de l'usuari/ària
-- IBAN de la targeta de crèdit usada.
-- Nom de la companyia de la transacció realitzada.
-- Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
-- Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.

CREATE VIEW 
	InformeTecnico AS
SELECT 
	transaction.id AS 'ID de la transacció',
    data_user.name AS "Nom de l'usuari/ària",
    data_user.surname AS "Cognom de l'usuari/ària",
    credit_card.iban AS 'IBAN de la targeta de crèdit usada',
    company.company_name AS 'Nom de la companyia de la transacció realitzada'
FROM 
	transaction
JOIN credit_card
ON transaction.credit_card_id = credit_card.id

JOIN data_user
ON transaction.user_id = data_user.id

JOIN company
ON transaction.company_id = company.id
ORDER BY 
	transaction.id DESC;
    
-- comprobació:
SELECT *
FROM informetecnico;