CREATE DATABASE notebook;
use notebook;
CREATE TABLE taccuino(
data_voto date,
id int not null,
nome nvarchar(20) not null,
cognome nvarchar (20) not null,
materia nvarchar (20) not null,
voto decimal not null,
nome_docente nvarchar(25) not null,
cognome_docente nvarchar(25) not null,
classe int not null,
sezione nvarchar(1) not null,
note nvarchar(100)
);
CREATE TABLE student(
id int primary key,
name nvarchar(20) not null,
surname nvarchar(20) not null,
class int,
sezione nvarchar(1) 
)

CREATE TABLE subject(
id int identity(1,1) primary key,
name_subject nvarchar (15) not null
);

CREATE TABLE teacher(
id int identity(1,1) primary key,
name nvarchar(25) not null,
surname nvarchar(25) not null
);

INSERT INTO student (id, name, surname, class, sezione)
SELECT DISTINCT id, nome, cognome, classe, sezione
FROM taccuino;

INSERT INTO subject (name_subject)
SELECT DISTINCT materia
FROM taccuino;

INSERT INTO teacher (name, surname)
SELECT DISTINCT nome_docente, cognome_docente
FROM taccuino;

CREATE TABLE mark(
id int identity(1,1) primary key,
date_mark date not null,
mark decimal not null,
id_student int not null,
subject nvarchar (25) not null,
name_teacher nvarchar(25) not null,
surname_teacher nvarchar(25) not null
);

INSERT INTO mark (date_mark, mark, id_student, subject, name_teacher, surname_teacher)
SELECT DISTINCT data_voto, voto, id, materia, nome_docente, cognome_docente
FROM taccuino;

ALTER TABLE mark 
ADD id_teacher INT, id_subject INT;

ALTER TABLE mark 
ADD notes NVARCHAR(100);

UPDATE m
SET	
	m.id_teacher = t.id,
	m.id_subject = s.id 
FROM mark m LEFT JOIN teacher t 
ON m.name_teacher  = t.name AND m.surname_teacher  = t.surname
LEFT JOIN subject s 
ON m.subject = s.name_subject;

UPDATE m
SET	
	m.notes = t.note
FROM mark m LEFT JOIN taccuino t 
ON m.date_mark  = t.data_voto;

ALTER TABLE mark  
DROP COLUMN name_teacher, surname_teacher, subject;

SELECT m.date_mark as 'Data', s.id as 'Matricola', s.name as 'Nome', s.surname as 'Cognome', sj.name_subject as 'Materia', m.mark as 'Voto', t.name as 'Nome Docente', t.surname as 'Cognome Docente', s.class as 'Classe', s.sezione as 'Sezione', m.notes as 'Note'
FROM mark m 
LEFT JOIN student s ON m.id_student = s.id
LEFT JOIN teacher t ON m.id_teacher = t.id
LEFT JOIN subject sj ON m.id_subject = sj.id; 
