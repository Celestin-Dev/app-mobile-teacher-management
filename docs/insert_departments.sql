-- =====================================================
-- Script d'insertion des départements ENI
-- =====================================================

INSERT INTO departments (id, name) VALUES (1, 'Génie Logiciel et Base de Données');
INSERT INTO departments (id, name) VALUES (2, 'Informatique Générale');
INSERT INTO departments (id, name) VALUES (3, 'Administration des Systèmes et Réseaux');
INSERT INTO departments (id, name) VALUES (4, 'Gouvernance et Ingénierie de Données');
INSERT INTO departments (id, name) VALUES (5, 'Objets Connectés et Cybersécurités');

-- Reset de la séquence PostgreSQL
SELECT setval(pg_get_serial_sequence('departments', 'id'), (SELECT MAX(id) FROM departments));