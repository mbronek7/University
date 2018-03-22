CREATE TABLE imiona
( Imie_ID INT IDENTITY PRIMARY KEY
, Imie VARCHAR(30)
);

CREATE TABLE nazwiska
( Nazwisko_ID INT IDENTITY PRIMARY KEY
, Nazwisko VARCHAR(30)
);

CREATE TABLE dane
( Imie VARCHAR(30)
, Nazwisko VARCHAR(30)
, CONSTRAINT PK_dane PRIMARY KEY (Imie,Nazwisko)
);

INSERT INTO dbo.imiona (Imie) VALUES 
('Michał'), ('Tomasz'), ('Dominika'), ('Magda'), ('Karol'),
('Czesław'), ('Alicja'), ('Dariusz'), ('Włodzimierz'), ('Małgorzata');

INSERT INTO dbo.nazwiska (Nazwisko) VALUES 
('Kowalski'), ('Nowak'), ('Iskariota'), ('Jezioro'), ('Kaczyński'),
('Bronikowski'), ('Grzesiak'), ('Wtorek'), ('Judaszek'), ('Zimmer');

drop procedure if exists generate
go
create procedure generate @n int
as
begin
  delete from dbo.dane;
  declare @condition int;
  set @condition = 
  (select count(distinct Imie) from dbo.imiona) * (select count(distinct Nazwisko) from dbo.nazwiska) / 2;
  if(@n>@condition)
    throw 51000, 'Nie mozna wygenerowac wiecej kombinacji niz polowa mozliwosci!', 1
  else
  begin
    declare @i int;
    declare @first varchar(30);
    declare @second varchar(30);
    set @i = 1;
    while @i<=@n
        begin
            set @first = (SELECT TOP 1 Imie FROM dbo.imiona ORDER BY NEWID());
            set @second = (SELECT TOP 1 Nazwisko FROM dbo.nazwiska ORDER BY NEWID());
            if ((select count(*) from dbo.dane where Imie=@first and Nazwisko=@second)=0)
                begin
                    insert into dbo.dane values (@first, @second);
                    set @i=@i+1;
                end
        end   
    end
end


go

exec generate 12;
go

select * from dane;
go


