**Descrizione del Progetto** 

L'azienda Banking Intelligence vuole sviluppare un modello di machine learning supervisionato per prevedere i comportamenti futuri dei propri clienti, basandosi sui dati transazionali e sulle caratteristiche del possesso di prodotti. Lo scopo del progetto è creare una tabella denormalizzata con una serie di indicatori (feature) derivati dalle tabelle disponibili nel database, che rappresentano i comportamenti e le attività finanziarie dei clienti.

**Obiettivo**

Il nostro obiettivo è creare una tabella di feature per il training di modelli di machine learning, arricchendo i dati dei clienti con vari indicatori calcolati a partire dalle loro transazioni e dai conti posseduti. La tabella finale sarà riferita all'ID cliente e conterrà informazioni sia di tipo quantitativo che qualitativo.

Indicatori Comportamentali da Calcolare

Gli indicatori saranno calcolati per ogni singolo cliente (riferiti a id_cliente) e includono:

**Indicatori di base**

Età del cliente (da tabella cliente).
Indicatori sulle transazioni
Numero di transazioni in uscita su tutti i conti.
Numero di transazioni in entrata su tutti i conti.
Importo totale transato in uscita su tutti i conti.
Importo totale transato in entrata su tutti i conti.

**Indicatori sui conti**

Numero totale di conti posseduti.
Numero di conti posseduti per tipologia (un indicatore per ogni tipo di conto).
Indicatori sulle transazioni per tipologia di conto
Numero di transazioni in uscita per tipologia di conto (un indicatore per tipo di conto).
Numero di transazioni in entrata per tipologia di conto (un indicatore per tipo di conto).
Importo transato in uscita per tipologia di conto (un indicatore per tipo di conto).
Importo transato in entrata per tipologia di conto (un indicatore per tipo di conto).
Piano per la Creazione della Tabella Denormalizzata

**1. Join delle Tabelle**
   
Per costruire la tabella finale, sarà necessario eseguire una serie di join tra le tabelle disponibili nel database.

**3. Calcolo degli Indicatori**
   
Gli indicatori comportamentali verranno calcolati utilizzando operazioni di aggregazione (SUM, COUNT) per ottenere i totali richiesti.
