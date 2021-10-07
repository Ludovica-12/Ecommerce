--create database Ecommerce

create table Cliente(
IdCliente nvarchar(10) not null,
Nome nvarchar(20) not null,
Cognome nvarchar(30) not null,
DataDiNascita date not null,
Constraint PK_CLIENTE primary key (IdCliente)
);

create table Indirizzo(
IdIndirizzo int identity(1,1) not null,
Tipo nvarchar(30) not null,
Citta nvarchar(50) not null,
Via nvarchar(30) not null,
Cap int not null,
NumeroCivico nvarchar(5) not null,
Provincia nvarchar(20) not null,
Nazione nvarchar(30)  not null,
IdCliente nvarchar(10) Constraint FK_IndirizzoCLIENTE foreign key references Cliente(IdCliente),
constraint PK_INDIRIZZO primary key (IdIndirizzo),
constraint CHK_TipoIndirizzo check (Tipo = 'Domicilio' OR Tipo = 'Residenza')
);

create table Carta(
IdCarta char(16) not null,
Tipo nvarchar(30) not null,
Scadenza date not null,
Saldo decimal  not null,
IdCliente nvarchar(10) Constraint FK_CartaCLIENTE foreign key references Cliente(IdCliente),
constraint PK_CARTA primary key (IdCarta),
constraint CHK_TipoCarta check (Tipo = 'Credito' OR Tipo = 'Debito'),
--check scadenza
--check saldo
);

Create table Ordine(
IdOrdine int identity(1,1) not null,
Stato nvarchar(20) not null,
DataOrdine date not null,
TotalePrezzo decimal not null,
IdCliente nvarchar(10) Constraint FK_OrdineCLIENTE foreign key references Cliente(IdCliente),
IdIndirizzo int Constraint FK_OrdineINDIRIZZO foreign key references Indirizzo(IdIndirizzo),
IdCarta char(16) Constraint FK_OrdineCARTA foreign key references Carta(IdCarta),
constraint PK_ORDINE primary key (IdOrdine),
constraint CHK_StatoOrdine check (Stato = 'Provvisorio' OR Stato = 'Confermato'),
--check datat ordine
constraint CHK_TotalePrezzo check (TotalePrezzo > 0)
);

Create table Prodotto(
IdProdotto int identity (1,1) not null,
Nome nvarchar(30) not null,
Descrizione nvarchar(200) not null,
Quantita int not null,
PrezzoUnitario decimal not null,
Constraint PK_PRODOTTO primary key (IdProdotto),
Constraint CHK_Quantita check (Quantita > 0),
Constraint CHK_Prezzo check (PrezzoUnitario>0)
);

Create table OrdineProdotto(
IdOrdine int not null Constraint FK_Ordine foreign key references Ordine(IdOrdine),
IdProdotto int not null Constraint FK_Prodotto foreign key references Prodotto(IdProdotto),
Quantita int not null,
Subtotale decimal not null,
Constraint CHK_QuantitaOP check (Quantita > 0),
Constraint CHK_Subtotale check (Subtotale>0)
);

--INSERT 
--insert into Cliente values ('mariorossi', 'Mario', 'Rossi', 06-08-1970)
--insert into Cliente values ('paologialli', 'Paolo', 'Gialli', 06-08-1958)
--insert into Cliente values ('luciabianchi', 'Lucia', 'Bianchi', 06-08-1988)
--insert into Cliente values ('saraverdi', 'Sara', 'Verdi', 06-08-1967)

--insert into Indirizzo values ('Domicilio', 'Roma', 'Nazionale', '00186', '31B', 'RM', 'Italia', 1)
--insert into Indirizzo values ('Residenza', 'Perugia', 'Carducci', '00175', '7', 'PG', 'Italia', 2)
--insert into Indirizzo values ('Domicilio', 'Milano', 'Roma', '00117', '1A', 'MI', 'Italia', 3)

--STORED PROCEDURE
Create procedure AggiungiIndirizzo
@TipoIndirizzo nvarchar(30),
@CittaIndirizzo nvarchar(50),
@ViaIndirizzo nvarchar(30),
@CapIndirizzo int,
@NumeroCivicoIndirizzo nvarchar(5),
@ProvinciaIndirizzo nvarchar(20),
@NazioneIndirizzo nvarchar(30),
@IdCliente nvarchar(10)

AS
declare @IDCLIENTE nvarchar(10)
select @IDCLIENTE = IdCliente from Cliente where IdCliente = @IdCliente

insert into Indirizzo values(@TipoIndirizzo, @CittaIndirizzo, @ViaIndirizzo,
							@CapIndirizzo, @NumeroCivicoIndirizzo, @ProvinciaIndirizzo,
							@NazioneIndirizzo, @IDCLIENTE);
Go

execute AggiungiIndirizzo 'Domicilio', 'Roma', 'Nazionale', 00189, '37B', 'RM', 'Italia', 'mariorossi'


Create procedure AggiungiCarta
@Tipo
@scadenza
@saldo