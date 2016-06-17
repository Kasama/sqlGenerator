-- ----------------------------------
CREATE TABLE Aluno (
NUSP NUMERIC 
,
CPF NUMERIC 
,
RG NUMERIC 
,
Nome VARCHAR(40) 
NOT NULL
,
DataNasc TIMESTAMP 
,
PRIMARY KEY ( NUSP )
,
UNIQUE ( CPF, RG )
);
-- ----------------------------------
CREATE TABLE Professor (
Nome VARCHAR(40) 
NOT NULL
,
NFUNC NUMERIC 
,
Titulacao VARCHAR(100) 
,
PRIMARY KEY ( NFUNC )
);
-- ----------------------------------
CREATE TABLE Diciplina (
Sigla CHAR(7) 
,
Nome VARCHAR(40) 
,
NCred NUMERIC 
,
Professor NUMERIC 
,
PRIMARY KEY ( Sigla )
,
FOREIGN KEY ( Professor ) REFERENCES Professor ( NFUNC )
);
-- ----------------------------------
CREATE TABLE Turma (
Sigla CHAR(7) 
,
Numero NUMERIC 
,
NAlunos NUMERIC 
,
PRIMARY KEY ( Sigla, Numero )
,
FOREIGN KEY ( Sigla ) REFERENCES Diciplina ( Sigla )
);
-- ----------------------------------
CREATE TABLE Matricula (
Sigla CHAR(7) 
,
Numero NUMERIC 
,
Aluno NUMERIC 
,
Ano NUMERIC 
,
Nota NUMERIC 
,
PRIMARY KEY ( Sigla, Numero, Aluno, Ano )
,
FOREIGN KEY ( Aluno ) REFERENCES Aluno ( NUSP )
,
FOREIGN KEY ( Sigla, Numero ) REFERENCES Turma ( Sigla, Numero )
);
