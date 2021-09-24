create database Pizzeria

--STRUTTURA DB:

create table Pizza(
IdPizza int identity(1,1) not null,
Nome varchar(30) not null unique,
Prezzo money not null,
constraint PK_Pizza primary key (IdPizza),
constraint CHK_Pizza check (Prezzo > 0)
)

create table Ingrediente(
IdIngrediente int identity(1,1) not null,
Nome varchar(30) not null unique,
Prezzo money not null,
PezziMagazzino int not null,
constraint PK_Ingrediente primary key(IdIngrediente),
constraint CHK_Ingrediente check (Prezzo > 0 and PezziMagazzino >= 0)
)

create table Ingrediente_Pizza(
IdIngrediente int not null,
IdPizza int not null,
constraint PK_Ingrediente_Pizza primary key(IdIngrediente,IdPizza),
constraint FK_Ingrediente_Ingrediente_Pizza foreign key (IdIngrediente) references Ingrediente(IdIngrediente),
constraint FK_Pizza_Ingrediente_Pizza foreign key(IdPizza) references Pizza(IdPizza)
)

-- INSERIMENTO DATI:

insert into Pizza values('Margherita',5)
insert into Pizza values('Bufala',7)
insert into Pizza values('Diavola',6)
insert into Pizza values('Quattro Stagioni',6.5)
insert into Pizza values('Porcini',7)
insert into Pizza values('Dioniso',8)
insert into Pizza values('Ortolana',8)
insert into Pizza values('Patate e Salsiccia',6)
insert into Pizza values('Pomodorini',6)
insert into Pizza values('Quattro Formaggi',7.5)
insert into Pizza values('Caprese',7.5)
insert into Pizza values('Zeus',7.5)

insert into Ingrediente values('Pomodoro',1.2,30)
insert into Ingrediente values('Mozzarella',2.5,10)
insert into Ingrediente values('Mozzarella di bufala',3.5,12)
insert into Ingrediente values('Spianata Piccante',3.5,2)
insert into Ingrediente values('Funghi',1.2,10)
insert into Ingrediente values('Carciofi',1.5,6)
insert into Ingrediente values('Prosciutto cotto',12,1)
insert into Ingrediente values('Olive',4.5,30)
insert into Ingrediente values('Funghi Porcini',12,3)
insert into Ingrediente values('Stracchino',5.4,2)
insert into Ingrediente values('Speck',22,1)
insert into Ingrediente values('Rucola',0.5,3)
insert into Ingrediente values('Grana',18,1)
insert into Ingrediente values('Verdure di stagione',5.5,40)
insert into Ingrediente values('Patate',0.99,32)
insert into Ingrediente values('Salsiccia',4.50,70)
insert into Ingrediente values('Pomodorini',2.70,40)
insert into Ingrediente values('Ricotta',8,31)
insert into Ingrediente values('Provola',12,22)
insert into Ingrediente values('Gorgonzola',20,2)
insert into Ingrediente values('Pomodoro fresco',0.80,40)
insert into Ingrediente values('Basilico',2,43)
insert into Ingrediente values('Bresaola',31,3)

insert into Ingrediente_Pizza values(1,1)
insert into Ingrediente_Pizza values(2,1)

insert into Ingrediente_Pizza values(1,2)
insert into Ingrediente_Pizza values(3,2)

insert into Ingrediente_Pizza values(1,3)
insert into Ingrediente_Pizza values(2,3)
insert into Ingrediente_Pizza values(4,3)

insert into Ingrediente_Pizza values(1,4)
insert into Ingrediente_Pizza values(2,4)
insert into Ingrediente_Pizza values(5,4)
insert into Ingrediente_Pizza values(6,4)
insert into Ingrediente_Pizza values(7,4)
insert into Ingrediente_Pizza values(8,4)

insert into Ingrediente_Pizza values(1,5)
insert into Ingrediente_Pizza values(2,5)
insert into Ingrediente_Pizza values(9,5)

insert into Ingrediente_Pizza values(1,6)
insert into Ingrediente_Pizza values(2,6)
insert into Ingrediente_Pizza values(10,6)
insert into Ingrediente_Pizza values(11,6)
insert into Ingrediente_Pizza values(12,6)
insert into Ingrediente_Pizza values(13,6)

insert into Ingrediente_Pizza values(1,7)
insert into Ingrediente_Pizza values(2,7)
insert into Ingrediente_Pizza values(14,7)

insert into Ingrediente_Pizza values(2,8)
insert into Ingrediente_Pizza values(15,8)
insert into Ingrediente_Pizza values(16,8)

insert into Ingrediente_Pizza values(2,9)
insert into Ingrediente_Pizza values(17,9)
insert into Ingrediente_Pizza values(18,9)

insert into Ingrediente_Pizza values(2,10)
insert into Ingrediente_Pizza values(19,10)
insert into Ingrediente_Pizza values(20,10)
insert into Ingrediente_Pizza values(13,10)

insert into Ingrediente_Pizza values(2,11)
insert into Ingrediente_Pizza values(21,11)
insert into Ingrediente_Pizza values(22,11)

insert into Ingrediente_Pizza values(2,12)
insert into Ingrediente_Pizza values(23,12)
insert into Ingrediente_Pizza values(12,12)


-- QUERY:

-- 1. Estrarre tutte le pizze con prezzo superiore a 6 euro

select * 
from pizza
where prezzo > 6

-- 2. Estrarre la pizza piu costosa

select nome as [Pizza/e piu cara]
from pizza 
where prezzo = (select max(prezzo) from pizza)				
				
-- 3. Estrarre le pizze bianche

select distinct p.nome as [Pizza/e Bianche]
from pizza p join Ingrediente_Pizza ipi on p.IdPizza = ipi.IdPizza
			join Ingrediente i on ipi.IdIngrediente = i.IdIngrediente
where p.nome not in(select p.nome
					from pizza p join Ingrediente_Pizza ipi on p.IdPizza = ipi.IdPizza
								join Ingrediente i on ipi.IdIngrediente = i.IdIngrediente
					where i.Nome = 'pomodoro')


-- 4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)

select p.nome as [Pizza/e con funghi]
from pizza p join Ingrediente_Pizza ipi on p.IdPizza = ipi.IdPizza
			join Ingrediente i on ipi.IdIngrediente = i.IdIngrediente
where i.Nome like '%funghi%' 


-- PROCEDURE:

-- 1. Inserimento di una nuova pizza (parametri: nome, prezzo)

create procedure Nuova_Pizza
@Nome varchar(30),
@Prezzo money

as
	begin
	begin try
		insert into pizza values (@Nome,@Prezzo)
	end try
	begin catch
		select ERROR_MESSAGE() as [Errore], ERROR_LINE() as [Riga Errore]
	end catch
	end

execute Nuova_Pizza 'Margherita', 7 -- violazione vincolo unique sul nome
execute Nuova_Pizza 'Salsiccia friarelli' , -3 -- violazione prezzo negativo
execute Nuova_Pizza 'Pizza di Prova 2', 1 

-- 2. Assegnazione di un ingrediente ad una pizza (parametri: nome pizza, nome ingrediente)

create procedure Aggiungi_Ingrediente_A_Pizza
@NomePizza varchar(30),
@NomeIngrediente varchar(30)
as
	declare @IdPizza int
	declare @IdIngrediente int

	begin try

		select @IdPizza = idpizza
		from pizza
		where nome = @NomePizza

		select @IdIngrediente = idingrediente
		from ingrediente
		where nome = @NomeIngrediente
	
		insert into Ingrediente_Pizza values(@IdIngrediente,@IdPizza)
		
	end try
	begin catch
		select ERROR_MESSAGE() as [Errore], ERROR_LINE() as [Riga Errore]
	end catch

execute Aggiungi_Ingrediente_A_Pizza 'Pizza di Prova','Mozzarella'
execute Aggiungi_Ingrediente_A_Pizza 'Pizza di Prova','Pomodoro'
execute Aggiungi_Ingrediente_A_Pizza 'Pizza di Prova','Funghi'

execute Aggiungi_Ingrediente_A_Pizza 'Pizza di Prova 2','Bresaola'


-- 3. Aggiornamento del prezzo di una pizza (parametri: nome pizza, nuovo prezzo)

create procedure Aggiorna_Prezzo_Pizza
@NomePizza varchar(30),
@NuovoPrezzo money
as
	declare @IdPizza int
	begin try
		select @IdPizza = idpizza
		from pizza
		where nome = @NomePizza

		update pizza set prezzo = @NuovoPrezzo where IdPizza = @IdPizza
	end try
	begin catch
		select ERROR_MESSAGE() as [Errore], ERROR_LINE() as [Riga Errore]
	end catch

execute Aggiorna_Prezzo_Pizza 'Pizza di Prova', 2
execute Aggiorna_Prezzo_Pizza 'Pizza di Prova 2', 3


-- 4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome ingrediente)

create procedure Elimina_Ingrediente_Pizza
@NomePizza varchar(30),
@NomeIngrediente varchar(30)
as 
	declare @IdPizza int
	declare @IdIngrediente int
	begin try
		select @IdPizza = idpizza
		from pizza
		where nome = @NomePizza

		select @IdIngrediente = idingrediente
		from ingrediente
		where nome = @NomeIngrediente
	
		delete from Ingrediente_Pizza where (IdIngrediente = @IdIngrediente and IdPizza = @IdPizza)
	end try
	begin catch
		select ERROR_MESSAGE() as [Errore], ERROR_LINE() as [Riga Errore]
	end catch

execute Elimina_Ingrediente_Pizza 'Pizza di Prova','Pomodoro'

-- per vedere se funziona Elimina_Ingrediente_Pizza
select * 
from pizza p join Ingrediente_Pizza ipi on ipi.idpizza = p.IdPizza
			join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente
where p.Nome = 'pizza di prova'

-- 5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente (paramento: nome ingrediente)

create procedure Incremento_Prezzo_Pizza_Con_Ingrediente
@NomeIngrediente nvarchar(30)
as
	begin try
		
		update pizza set prezzo = (prezzo + (prezzo*10/100)) where idpizza in (select p.idpizza
												from pizza p join Ingrediente_Pizza ipi on ipi.idpizza = p.IdPizza
												join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente
												where i.Nome = @NomeIngrediente)
	end try
	begin catch
			select ERROR_MESSAGE() as [Errore], ERROR_LINE() as [Riga Errore]
	end catch


execute Incremento_Prezzo_Pizza_Con_Ingrediente 'Rucola'

select * from pizza

-- FUNZIONI:

-- 1. Tabella listino pizze (nome, prezzo) ordinato alfabeticamente (parametri: nessuno)create function Listino_Prezzi_Pizze()returns tableas	return 			select top 1000 nome as [Pizza], prezzo as [Prezzo]		from pizza 		order by nomeselect * from Listino_Prezzi_Pizze()-- 2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome ingrediente)create function Listino_Prezzi_Pizze_Con_Ingrediente(@NomeIngrediente varchar(30))returns tableas	return 		select p.nome as [Pizza], p.prezzo as [Prezzo]	from pizza p join Ingrediente_Pizza ipi on ipi.idpizza = p.IdPizza
			join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente	where i.Nome = @NomeIngredienteselect * from Listino_Prezzi_Pizze_Con_Ingrediente('Olive')-- 3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente (parametri: nome ingrediente)create function Listino_Prezzi_Pizze_Senza_Ingrediente(@NomeIngrediente varchar(30))returns tableas	return 		select  p.nome, p.prezzo	from pizza p join Ingrediente_Pizza ipi on ipi.idpizza = p.IdPizza
			join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente	where p.Nome not in (					select p.nome					from pizza p join Ingrediente_Pizza ipi on ipi.idpizza = p.IdPizza
							join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente					where i.Nome = @NomeIngrediente)	group by p.nome, p.Prezzo		select * from Listino_Prezzi_Pizze_Senza_Ingrediente('Pomodoro')-- 4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)create function Numero_Pizze_Con_Ingrediente(@NomeIngrediente varchar(30))returns intasbegin	declare @NumeroPizze int	declare @IdIngrediente int			select @IdIngrediente = idingrediente	from ingrediente	where nome = @NomeIngrediente	select @NumeroPizze = count(*) 	from pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza				join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente	where i.IdIngrediente = @IdIngrediente	return @NumeroPizzeendselect dbo.Numero_Pizze_Con_ingrediente('Grana') as [Numero Pizze]-- 5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice ingrediente)create function Numero_Pizze_Senza_Ingrediente(@IdIngrediente int)returns intasbegin	declare @NumeroPizze int	select @NumeroPizze = count(x.nome)	from (select distinct p.nome 	from pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza				join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente	where p.nome not in(select p.nome						from pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza									join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente						where i.IdIngrediente = @IdIngrediente )) x	return @NumeroPizzeendselect dbo.Numero_Pizze_Senza_Ingrediente(2) as [Numero Pizze]select count(x.nome)from (select distinct p.nome 	from pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza				join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente	where p.nome not in(select p.nome						from pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza									join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente						where i.Nome = 'pomodoro' )) x-- 6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)create function Numero_Ingredienti_Pizza(@NomePizza varchar(30))returns intasbegin	declare @NumeroIngredienti int	declare @IdPizza int		select @IdPizza = idpizza	from pizza	where nome = @NomePizza	select @NumeroIngredienti = count(*) 	from pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza				join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente	where p.IdPizza = @IdPizza	return @NumeroIngredientiendselect dbo.Numero_Ingredienti_Pizza('Zeus') as [Numero Ingredienti]-- VIEW-- Realizzare una view che rappresenta il menu con tutte le pizzecreate view Menu(Pizza, Prezzo)as(select nome, prezzofrom pizza)select * from Menu	-- OPZIONALE :--la vista deve restituire una tabella con prima colonna
--contenente il nome della pizza, seconda colonna il prezzo e terza
--colonna la lista unica di tutti gli ingredienti separati da virgola

create view Menu_Con_Elenco_Ingredienti(Pizza, Prezzo, Ingredienti)as(	select nome, prezzo, dbo.Elenco_Ingredienti_Pizza(nome)	from pizza)select * from Menu_Con_Elenco_Ingredienticreate function Elenco_Ingredienti_Pizza(@NomePizza varchar(30))returns varchar(100)asbegin	declare @ElencoIngredienti varchar(100)	select @ElencoIngredienti = coalesce(@ElencoIngredienti + ', ','') + i.nome	from (pizza p join Ingrediente_Pizza ipi on ipi.IdPizza = p.IdPizza				join Ingrediente i on i.IdIngrediente = ipi.IdIngrediente)	where p.nome = @NomePizza 	return @ElencoIngredientiendselect dbo.Elenco_Ingredienti_Pizza('Margherita') as [Elenco Ingredienti]