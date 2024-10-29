/*
ANALISI DI UN SISTEMA BANCARIO

Creare una tabella denormalizzata che contenga indicatori comportamentali sul cliente, 
calcolati sulla base delle transazioni e del possesso prodotti. 
Lo scopo è creare le feature per un possibile modello di machine learning supervisionato.

Ogni indicatore va riferito al singolo id_cliente.

- Età
- Numero di transazioni in uscita su tutti i conti
- Numero di transazioni in entrata su tutti i conti
- Importo transato in uscita su tutti i conti
- Importo transato in entrata su tutti i conti
- Numero totale di conti posseduti
- Numero di conti posseduti per tipologia (un indicatore per tipo)
- Numero di transazioni in uscita per tipologia (un indicatore per tipo)
- Numero di transazioni in entrata per tipologia (un indicatore per tipo)
- Importo transato in uscita per tipologia di conto (un indicatore per tipo)
- Importo transato in entrata per tipologia di conto (un indicatore per tipo)
*/

/*Per svolgere il progetto, creo tante temporary table per poi effettuare un join finale costruendo la tabella con le info desiderate. */


select * from banca.cliente;
select * from banca.conto;
select * from banca.tipo_conto;
select* from banca.tipo_transazione;
select * from banca.transazioni;

-- TEMPORARY TABLE ETA'

create temporary table banca.table_eta as select id_cliente, round(datediff(current_date(), data_nascita)/365) as eta from banca.cliente;

select * from banca.table_eta;


--  TEMPORATY TABLE Numero di transazioni in uscita su tutti i conti

create temporary table banca.num_trans_uscita as
select cont.id_cliente, count(tipo_trans.segno) as numero_transazioni_uscita
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
where segno= '-'
group by 1;

select * from banca.num_trans_uscita;

--  TEMPORATY TABLE Numero di transazioni in entrata su tutti i conti
create temporary table banca.num_trans_entrata as
select cont.id_cliente, count(tipo_trans.segno) as numero_transazioni_entrata
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
where segno= '+'
group by 1;

select * from banca.num_trans_entrata;

--  TEMPORATY TABLE importo transato in uscita su tutti i conti
create temporary table banca.importo_uscita as
select cont.id_cliente, round(sum(trans.importo),2) as importo_uscita
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
where tipo_trans.segno= '-' 
group by 1;

select * from banca.importo_uscita;

--  TEMPORATY TABLE importo transato in entrata su tutti i conti

create temporary table banca.importo_entrata as
select cont.id_cliente, round(sum(trans.importo),2) as importo_entrata
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
where tipo_trans.segno= '+' 
group by 1;

select * from banca.importo_entrata;

-- TEMPORARY TABLE Numero totale di conti posseduti

create temporary table banca.conti_posseduti as
select id_cliente, count(id_tipo_conto) as numero_conti_posseduti
from banca.conto
group by id_cliente;

select * from banca.conti_posseduti;


-- TEMPORATY TABLE Numero di conti posseduti per tipologia (un indicatore per tipo)

create temporary table banca.tipo_conti as 
select cont.id_cliente,
count(case when tipo_cont.id_tipo_conto='0' then desc_tipo_conto else null end) conto_base,
count(case when tipo_cont.id_tipo_conto='1' then desc_tipo_conto else null end) conto_business,
count(case when tipo_cont.id_tipo_conto='2' then desc_tipo_conto else null end) conto_privati,
count( case when tipo_cont.id_tipo_conto='3' then desc_tipo_conto else null end) conto_famiglie
from banca.conto cont
left join banca.tipo_conto tipo_cont
on cont.id_tipo_conto= tipo_cont.id_tipo_conto
group by 1;

select * from banca.tipo_conti;

-- TEMPORARY TABLE  Numero di transazioni in uscita per tipologia (un indicatore per tipo)
create temporary table  banca.numero_tipo_trans_uscita as
select cont.id_cliente,
count(case when tipo_trans.desc_tipo_trans='Acquisto su Amazon' then desc_tipo_trans else null end) n_trans_uscita_Amazon,
count(case when tipo_trans.desc_tipo_trans='Rata mutuo' then desc_tipo_trans else null end) n_trans_uscitaRata_mutuo,
count(case when tipo_trans.desc_tipo_trans='Hotel' then desc_tipo_trans else null end) n_trans_uscita_Hotel,
count(case when tipo_trans.desc_tipo_trans='Biglietto aereo' then desc_tipo_trans else null end) n_trans_uscita_Biglietto_aereo,
count(case when tipo_trans.desc_tipo_trans='Supermercato' then desc_tipo_trans else null end) n_trans_uscita_Supermercato
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
group by 1;

select *from banca.numero_tipo_trans_uscita;

-- TEMPORARY TABLE Numero di transazioni in entrata per tipologia (un indicatore per tipo)
create temporary table banca.numero_tipo_trans_entrata as
select cont.id_cliente,
count(case when tipo_trans.desc_tipo_trans='Stipendio' then desc_tipo_trans else null end) n_trans_entrata_Stipendio,
count(case when tipo_trans.desc_tipo_trans='Pensione' then desc_tipo_trans else null end) n_trans_entrata_Pensione,
count(case when tipo_trans.desc_tipo_trans='Dividendi' then desc_tipo_trans else null end) n_trans_entrata_dividendi
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
group by 1;

select *from banca.numero_tipo_trans_entrata;



-- TEMPORARY TABLE Importo transato in uscita per tipologia di conto (un indicatore per tipo)

create temporary table banca.importo_uscita_per_conto as
select cont.id_cliente,
sum( case when cont.id_tipo_conto='0' then trans.importo else null end) importo_uscita_conto_base,
sum(case when cont.id_tipo_conto='1' then trans.importo  else null end) importo_uscita_conto_business,
sum(case when cont.id_tipo_conto='2' then trans.importo  else null end) importo_uscita_conto_privati,
sum( case when cont.id_tipo_conto='3' then trans.importo else null end) importo_uscita_conto_famiglie
from banca.transazioni trans
left join banca.conto cont
on cont.id_conto= trans.id_conto
left join banca.tipo_transazione tipo_trans
on trans.id_tipo_trans= tipo_trans.id_tipo_transazione
where tipo_trans.segno='-'
group by 1;

select *from banca.importo_uscita_per_conto;

-- TEMPORARY TABLE Importo transato in entrata per tipologia di conto (un indicatore per tipo)

create temporary table banca.importo_entrata_per_conto as
select cont.id_cliente,
sum( case when cont.id_tipo_conto='0' then trans.importo else null end) importo_entrata_conto_base,
sum(case when cont.id_tipo_conto='1' then trans.importo  else null end) importo_entrata_conto_business,
sum(case when cont.id_tipo_conto='2' then trans.importo  else null end) importo_entrata_conto_privati,
sum( case when cont.id_tipo_conto='3' then trans.importo else null end) importo_entrata_conto_famiglie
from banca.transazioni trans
left join banca.conto cont
on cont.id_conto= trans.id_conto
left join banca.tipo_transazione tipo_trans
on trans.id_tipo_trans= tipo_trans.id_tipo_transazione
where tipo_trans.segno='+'
group by 1;

select *from banca.importo_entrata_per_conto;


-- EFFETTUO IL JOIN DI TUTTE LE TEMPORARY TABLE per avere la tabella finale

/* create table banca.final_table as */
create table banca.final_table as
select * 
from banca.table_eta eta
left join banca.num_trans_uscita ntu USING (id_cliente)
left join banca.num_trans_entrata nte USING (id_cliente)
left join banca.importo_uscita iu  USING (id_cliente)
left join banca.importo_entrata ie  USING (id_cliente)
left join banca.conti_posseduti cp  USING (id_cliente)
left join banca.tipo_conti tp USING (id_cliente)
left join banca.numero_tipo_trans_uscita nttu USING (id_cliente)
left join banca.numero_tipo_trans_entrata ntte USING (id_cliente)
left join banca.importo_uscita_per_conto iupc USING (id_cliente)
left join banca.importo_entrata_per_conto iepc USING (id_cliente);

select * from banca.final_table ;
